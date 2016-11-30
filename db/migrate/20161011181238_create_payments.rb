class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.datetime :time
      t.decimal :amount,            precision: 12, scale: 2, null: false
      t.string :contributor
      t.text :notes

      t.timestamps null: false
    end
  end
end
