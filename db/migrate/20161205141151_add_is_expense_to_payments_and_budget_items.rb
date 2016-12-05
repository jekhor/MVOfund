class AddIsExpenseToPaymentsAndBudgetItems < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :is_expense, :boolean, null: false, default: false
    add_column :budget_items, :is_expense, :boolean, null: false, default: false
  end
end
