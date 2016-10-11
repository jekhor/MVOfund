class AddShortDecriptionToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :short_description, :text, default: '', null: false
  end
end
