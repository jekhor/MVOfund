class Payment < ActiveRecord::Base
  belongs_to :campaign, inverse_of: :budget_items
  belongs_to :budget_item, inverse_of: :payments

  validates :time, presence: true
  validates :amount, presence: true
  validates :amount, numericality: {other_than: 0}
  validates :campaign, presence: true

  #TODO: validate if campaign and budget_item.campaign are same

  include FinanceRecord
end
