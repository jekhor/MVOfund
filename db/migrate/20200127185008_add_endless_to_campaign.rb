class AddEndlessToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :endless, :boolean
  end
end
