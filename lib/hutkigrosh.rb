#!/usr/bin/ruby
# encoding: utf-8

require 'rest-client'
require 'json'

module HutkiGrosh
  class HGError < Exception
  end

  module HGUtils
    def self.json2time(str)
      if str =~ /\/Date\(([0-9]+)([+\-][0-9]+)\)\//
        return Time.at($1.to_i / 1000)
      end
      nil
    end

    def self.time2json(time)
      sprintf("/Date(%d%s)/", time.to_i * 1000, time.strftime("%z"))
    end
  end

  MANDATORY_ATTRS = [:eripId, :invId, :dueDt, :addedDt, :amt, :curr,
                     :notifyByMobilePhone, :notifyByEMail, :statusEnum,
                     :products]
  class Bill

    def initialize(options={})
      @attributes = Hash.new
      @attributes[:products] = Array.new

      options = options.inject({}) {|memo, (k, v)| memo[k.to_sym] = v; memo }
      options[:products] = options[:products].map {|p| p.inject({}) {|memo, (k, v)| memo[k.to_sym] = v; memo }} if options[:products]
      @attributes.merge! options

      [:dueDt, :addedDt, :payedDt].each do |key|
        @attributes[key] = HGUtils.json2time(@attributes[key]) if @attributes[key].kind_of? String
      end
    end

    def [](key)
      @attributes[key.to_sym]
    end

    def []=(key, val)
      @attributes[key.to_sym] = val
    end

    def validate
      errors = []
      MANDATORY_ATTRS.each do |key|
        errors << {attribute: key, error: "#{key} should be defined"} if @attributes[key].nil?
      end
      [errors.empty?, errors]
    end

    def to_json
      valid, errors = validate
      raise HGError, "Bill is invalid:\n#{errors.map {|e| e[:error]}.join("\n")}" unless valid
      attrs = @attributes.dup
      [:dueDt, :addedDt, :payedDt].each do |key|
        attrs[key] = HGUtils.time2json(attrs[key]) if attrs[key].kind_of? Time
      end

      JSON.pretty_generate attrs
    end

    def to_s
      to_json
    end
  end

  ERRORS = {
    3221291009 => 'Общая ошибка сервиса',
    3221291521 => 'Нет информации о счете',
    3221291522 => 'Нет возможности удалить счет',
    3221291523 => 'Общая ошибка выставления счета',
    3221291524 => 'Не указан номер счета',
    3221291525 => 'Счет не уникальный',
    3221291526 => 'Счет уже выставлен, но срок оплаты прошел',
    3221291527 => 'Счет выставлен и оплачен',
    3221291528 => 'Не указано количество товаров/услуг в заказе',
    3221291529 => 'Не указана сумма счета',
    3221291530 => 'Не указано наименование товара',
    3221291531 => 'Общая сумма счета меньше нуля',
    3221291601 => 'Возвращены не все счета',
    3221292033 => 'Общая ошибка установки курсов валют',
    3221292034 => 'Не указан коэффициент к курсу НБ РБ',
    3221292035 => 'Не определены курсы валют поставщика услуг',
    3221292036 => 'Не установлен режим пересчета курсов валют',
    3221292289 => 'Общая ошибка при получении курсов валют',
  }

  class HutkiGrosh

    def initialize(base_url, user, password)
      @base_url = base_url
      @auth = {username: user, password: password}
      @cookies = Hash.new
      RestClient.log = STDERR
    end

    def login
      body = {
        user: @auth[:username],
        pwd: @auth[:password]
      }
      response = query_api :post, '/API/v1/Security/Login', body

      raise HGError, "Authentication at service #{@base_url} failed" if response.body != 'true'

      @cookies = response.cookies
      true
    end

    def logout
      query_api :post, '/API/v1/Security/LogOut'
    end

    def post_bill(bill)
      r = query_api :post, '/API/v1/Invoicing/Bill', bill
      bill_status = JSON.parse r.body
      raise HGError, ERRORS[bill_status['status']] unless bill_status['status'] == 0
      bill_status['billID']
    end

    def get_bill(bill_id)
      r = query_api :get, "/API/v1/Invoicing/Bill(#{bill_id})"
      bill_status = JSON.parse r.body
      raise HGError, ERRORS[bill_status['status']] unless bill_status['status'] == 0
      Bill.new(bill_status['bill'])
    end

    def delete_bill(bill_id)
      r = query_api :delete, "/API/v1/Invoicing/Bill(#{bill_id})"
      bill_status = JSON.parse r.body
      raise HGError, ERRORS[bill_status['status']] unless bill_status['status'] == 0
      bill_status
    end

    def bills
      r = query_api :get, "/API/v1/Invoicing/Bills(0,1000,1)"
      res = JSON.parse r.body
      raise HGError, ERRORS[res['status']] unless res['status'] == 0
      res['bill']
    end

    def bill_status(bill_id)
      r = query_api :get, "/API/v1/Invoicing/BillStatus(#{bill_id})"
      bill_status = JSON.parse r.body
      raise HGError, ERRORS[bill_status['status']] unless bill_status['status'] == 0
      bill_status
    end

    def payed_bills(erip_id)
      r = query_api :get, "/API/v1/Invoicing/PayedBills(#{erip_id},0)"
      res = JSON.parse r.body
      # Сервис возвращает ошибку, если оплаченных счетов нет
      return [] if res['status'] == 3221291523
      raise HGError, ERRORS[res['status']] unless res['status'] == 0
      res['bill']
    end

    def bgpb_pay_form(data)
      r = query_api :post, "/API/v1/Pay/BgpbPay", data
      res = JSON.parse r.body
      raise HGError, ERRORS[res['status']] unless res['status'] == 0
      res['form']
    end

    private

    def log(message)
      return unless RestClient.log
      RestClient.log << message
    end

    def query_api(method, path, body = nil)
      body = body.to_json unless body.nil?
      begin
        r = RestClient::Request.execute method: method,
          url: @base_url + path,
          payload: body,
          cookies: @cookies,
          headers: {content_type: :json, accept: :json}
      rescue => e
        log e.message
        log r.body if r
        raise e
      end
      r
    end
  end
end


if $0 == __FILE__
  hg = HutkiGrosh::HutkiGrosh.new 'https://trial.hgrosh.by',  'jekhor@bike.org.by', 'Og*56$#J'
  hg.login

  puts hg.get_bill(1005112370916837592).inspect

  bill = {
    eripId: 10051001,
    invId: '16',
    dueDt: Time.now + 86400,
    addedDt: Time.now,
    amt: 15000.00,
    curr: 'BYN',
#    fullName: '',
#    mobilePhone: '',
    notifyByMobilePhone: false,
    notifyByEMail: false,
    statusEnum: -1,
    products: [
      {
      "invItemId"=>"HG",
      "desc"=>"Оплата членских взносов",
      "count"=>1
    }
    ]
  }

  b = HutkiGrosh::Bill.new(bill)

  begin
    puts hg.post_bill(b).inspect
  rescue => e
    puts e.message
  end

  bills = hg.bills
  puts bills.inspect

  hg.delete_bill(bills.last['billID'])

  bills = hg.bills
  puts bills.inspect

  puts hg.bill_status(bills.last['billID'])

  puts hg.payed_bills(10051001)

  puts hg.bgpb_pay_form({
    order_data: {
      eripId: 10051001,
      spClaimId: '14',
      amount: 15000,
      currency: 933,
#      clientFio: 'Пупкин Васисуалий',
#      clientAddress: '',
#      trxId: 123,
    },
    returnUrl: 'http://localhost:3000/hg-return',
    cancelReturnUrl: 'http://localhost:3000/hg-cancel',
    submitValue: 'Оплатить картой'
  })

  hg.logout
end
