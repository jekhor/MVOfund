class ChangeCheckoutsRawStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :checkouts, :raw_status, :text
  end
end
