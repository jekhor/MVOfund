class CheckoutsController < ApplicationController
  before_action :set_checkout, only: :return

  def return
    process_checkout_changes

    respond_to do |format|
      if @checkout.status == 'successful'
        format.html { redirect_to campaign_path(@checkout.campaign), flash: {success: "Платёж совершён успешно"} }
      else
        format.html { redirect_to campaign_path(@checkout.campaign), alert: "Платёж не удался: #{@checkout.message}" }
      end
    end
  end

  def notify
    @checkout = Checkout.find_by(token: params[:transaction][:additional_data][:vendor][:token])

    process_checkout_changes

    if @checkout.status == 'successful'
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def process_checkout_changes
    handle_checkout_status_change if checkout_status_changed?
  end

  def handle_checkout_status_change
    if @checkout.status == 'successful'
      unless @checkout.payment.blank?
        p = @checkout.payment
        logger.error "Payment for checkout #{@checkout.id} already exists, overwrite"
      else
        p = Payment.new
      end
      p.checkout = @checkout
      p.amount = @checkout.amount
      p.is_expense = false
      p.time = Time.now
      p.campaign = @checkout.campaign
      p.contributor = @checkout.customer['email']
      p.payment_number = @checkout.uid || "checkout_#{@checkout.id}"
      begin
        bi = BudgetItem.where('campaign_id = ? AND title = ?', p.campaign.id, 'Пожертвования').first
        p.budget_item = bi
      rescue
      end

      unless p.save
        logger.error p.inspect
        logger.error p.inspect.errors
        raise "Cannot save payment"
      end
    end
  end

  def checkout_status_changed?
    old_status = @checkout.status
    @checkout.update_status!

    old_status != @checkout.status
  end

  def set_checkout
    @checkout = Checkout.find_by(token: params[:token])
  end

  def checkout_params
    params.permit(:token, :status, :uid)
  end
end
