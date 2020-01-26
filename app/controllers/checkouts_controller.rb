class CheckoutsController < ApplicationController
  before_action :set_checkout

  def return
    @checkout.update_status!

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
      p.payment_number = "checkout_#{@checkout.id}"
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

    respond_to do |format|
      if @checkout.status == 'successful'
        format.html { redirect_to campaign_path(@checkout.campaign), flash: {success: "Платёж совершён успешно"} }
      else
        format.html { redirect_to campaign_path(@checkout.campaign), alert: "Платёж не удался: #{@checkout.message}" }
      end
    end
  end

  private
  def set_checkout
    @checkout = Checkout.find_by(token: params[:token])
  end

  def checkout_params
    params.permit(:token, :status, :uid)
  end
end
