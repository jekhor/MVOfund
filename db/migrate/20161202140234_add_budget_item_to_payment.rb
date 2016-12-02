class AddBudgetItemToPayment < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :payments, :budget_item, foreign_key: true
  end
end
