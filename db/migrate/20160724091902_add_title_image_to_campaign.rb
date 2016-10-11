class AddTitleImageToCampaign < ActiveRecord::Migration
  def change
    add_reference :campaigns, :title_image
    add_index :campaigns, :title_image_id
  end
end
