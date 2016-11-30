class RemoveFundedFromCampaigns < ActiveRecord::Migration[5.0]
  def change
    remove_column :campaigns, :funded
  end
end
