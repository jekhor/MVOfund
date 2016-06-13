class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.string :image_secure_token
      t.string :original_filename
      t.string :image

      t.timestamps null: false
    end
  end
end
