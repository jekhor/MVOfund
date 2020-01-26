class Payment < ActiveRecord::Base
  belongs_to :campaign, inverse_of: :budget_items
  belongs_to :budget_item, inverse_of: :payments
  has_one :checkout, inverse_of: :payment

  validates :time, presence: true
  validates :amount, presence: true
  validates :amount, numericality: {other_than: 0}
#  validates :campaign, presence: true
  validates :payment_number, uniqueness: true, allow_nil: true

  #TODO: validate if campaign and budget_item.campaign are same

  include FinanceRecord

  def self.sum_for_bi(budget_item)
    res = select('sum(amount) AS sum').where('budget_item_id = ?', budget_item.id)
    res.first.sum.nil? ? 0 : res.first.sum
  end

end
