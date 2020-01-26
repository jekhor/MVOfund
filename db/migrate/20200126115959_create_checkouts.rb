class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :pay_processor, null: false
      t.string :token
      t.string :redirect_url
      t.string :status
      t.string :message
      t.string :customer
      t.string :raw_status
      t.belongs_to :campaign, foreign_key: true, null: false
      t.belongs_to :payment, foreign_key: true, null: true

      t.timestamps
    end
  end
end
