class AddPaymentNumberToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :payment_number, :integer, null: true
  end
end
