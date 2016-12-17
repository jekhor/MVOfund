require 'hutkigrosh'

class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :hg_notify]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    p = params.fetch(:payment,{}).permit([:budget_item_title])

    if @payment.budget_item.nil? and !p[:budget_item_title].nil? and !@payment.campaign.nil?
      bi = BudgetItem.where('campaign_id = ? AND title = ?', @payment.campaign.id, p[:budget_item_title]).first
      @payment.budget_item = bi
    end

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_budget_items
    @budget_items = BudgetItem.where('campaign_id = ?', params[:campaign_id])
    respond_to do |format|
      format.js
    end
  end

  def hg_notify
    payment = nil
    foreign_payment = false
    bill_id = params.permit(:purchaseid)[:purchaseid]
    c = Rails.configuration.hutkigrosh
    hg = HutkiGrosh::HutkiGrosh.new(c.base_url, c.user, c.password)
    begin
      hg.login
      bill = hg.get_bill(bill_id)

      puts bill.inspect

      case bill[:eripId]
      when c.erip_donation_id
        payment = Payment.new
        begin
          campaign = Campaign.find(bill[:invId].to_i)
          payment.campaign = campaign
          bi = BudgetItem.where('campaign_id = ? AND title = ?', campaign.id, 'Пожертвования').first
          payment.budget_item = bi
        rescue
        end
        payment.time = bill[:payedDt]
        payment.amount = bill[:amt]
        payment.contributor = bill[:fullName]
        payment.is_expense = false
        payment.payment_number = bill_id.to_s
        payment.notes = bill.to_s
      else
        foreign_payment = true
        logger.info "Payment notification with unknown ERIP ID: #{bill.to_s}"
      end
    rescue HutkiGrosh::HGError => e
      logger.info "#{e.class.to_s}: #{e.message}"
    ensure
      hg.logout
    end

    if (payment and payment.save) or foreign_payment
      head :ok
    else
      logger.info "Payment save failed: payment=#{payment.inspect}"
      logger.info payment.errors.messages.inspect if payment
      head :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.fetch(:payment, {}).permit([:amount, :time, :contributor, :notes, :is_expense, :campaign_id, :budget_item_id, :payment_number])
    end
end
