class AddHiddenAndClosedToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :hidden, :boolean, default: false
    add_column :campaigns, :closed, :boolean, default: false
  end
end
