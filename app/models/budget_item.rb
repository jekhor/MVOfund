class BudgetItem < ApplicationRecord
  belongs_to :campaign, inverse_of: :budget_items
  has_many :payments, inverse_of: :budget_item, dependent: :nullify

  def earning?
    !is_expense
  end

  def expense?
    is_expense
  end

end
