class AddUidToCheckout < ActiveRecord::Migration[5.2]
  def change
    add_column :checkouts, :uid, :string
  end
end
