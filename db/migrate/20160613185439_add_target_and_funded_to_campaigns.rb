class AddTargetAndFundedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :target, :decimal, precision: 12, scale: 2, default: 0
    add_column :campaigns, :funded, :decimal, precision: 12, scale: 2, default: 0
    add_column :campaigns, :end_date, :date
  end
end
