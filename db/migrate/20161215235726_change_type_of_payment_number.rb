class ChangeTypeOfPaymentNumber < ActiveRecord::Migration[5.0]
  def change
    change_column :payments, :payment_number, :string 
  end
end
