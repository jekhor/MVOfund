class CreateBudgetItems < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_items do |t|
      t.belongs_to :campaign, foreign_key: true, null: false
      t.string :title
      t.decimal :amount, precision: 12, scale: 2, default: 0

      t.timestamps
    end
  end
end
