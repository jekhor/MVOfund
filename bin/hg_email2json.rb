#!/usr/bin/ruby
# encoding: utf-8

require 'json'
require 'time'

payment = {}

type = nil
member_card_no = nil
text = []

STDIN.each_line do |line|
  line.chomp!
  text << line

  if line =~ /\s*Оплачено ([0-9., ]+)\s*BYN/
    payment[:amount] = $1.gsub(',', '.').delete(' ').to_f
    next
  end

  if line =~ /\s*Cчет №\s*(([0-9]{2})\.?([0-9]{2})\.?([0-9]{4}))/
    payment[:user_account] = $1
    next
  end

  if line =~ /\s*Cчет №\s*([0-9]{1,6})\s*$/
    member_card_no = $1.to_i
    payment[:user_account] = $1
    next
  end

  if line =~ /\s*Дата совершения платежа\s+(.*)/
    payment[:date] = Time.parse($1)
    next
  end

  if line =~ /\s*Идентификатор операции у расчётного агента\s*([^\s]+)/
    payment[:number] = $1
    next
  end

  if line =~ /\s*Идентификатор операции в Системе "Расчёт" \(ЕРИП\)\s*([^\s]+)/
    payment[:erip_number] = $1
    next
  end

  if line =~ /\s*ФИО:\s*([^\s].*)$/
    payment[:fio] = $1
    next
  end

  if line =~ /\s*Услуга.*\( ([0-9]+) \)/
    case $1
    when '10051001'
      type = :membership
    when '10051002'
      type = :initial
    when '10051003'
      type = :donation
    end
    next
  end

end

payment[:notes] = text.join("\n")


exit if type != :donation

p = {}
unless payment[:fio].nil?
  while payment[:fio][0].ord == 160 or payment[:fio][0].ord == 32
    payment[:fio] = payment[:fio][1..-1]
    if payment[:fio].size == 0
      payment[:fio] = nil
      break
    end
  end
end

p[:time] = payment[:date]
p[:amount] = payment[:amount]
p[:contributor] = payment[:fio]
p[:payment_number] = payment[:erip_number]
p[:notes] = payment[:notes]
p[:campaign_id] = payment[:user_account]
p[:is_expense] = false
p[:budget_item_title] = 'Пожертвования'

puts({payment: p}.to_json)
