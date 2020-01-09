class AddCampaignNumberToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :campaign_number, :integer, unique: true
  end
end
