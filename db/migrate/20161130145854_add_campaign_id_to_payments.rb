class AddCampaignIdToPayments < ActiveRecord::Migration
  def change
    add_belongs_to :payments, :campaign, foreign_key: true
  end
end
