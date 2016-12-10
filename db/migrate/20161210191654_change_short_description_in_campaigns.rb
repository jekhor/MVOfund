class ChangeShortDescriptionInCampaigns < ActiveRecord::Migration[5.0]
  def change
    change_column :campaigns, :short_description, :text, null: false
  end
end
