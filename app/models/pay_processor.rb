class PayProcessor
  def initialize(options = {})
  end

  def checkout(sum, options = {})
  end

  def update_checkout_status!(checkout)
  end

  def self.create(options = {})
    if Rails.configuration.pay_processor == 'bePaid' then
      p = PayProcessorBepaid.new(options)
      return p
    end

    raise "No Payment Processor configured"
  end
end
