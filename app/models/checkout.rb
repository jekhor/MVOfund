class Checkout < ApplicationRecord
  belongs_to :campaign, inverse_of: :checkouts
  belongs_to :payment, inverse_of: :checkout

  serialize :customer, JSON

  validates :amount, presence: true
  validates :amount, numericality: {other_than: 0}

  def update_status!
    payproc = PayProcessor.create

    payproc.update_checkout_status!(self)
  end
end
