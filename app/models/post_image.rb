class PostImage < ActiveRecord::Base
  has_many :campaigns, inverse_of: :title_image, dependent: :nullify, foreign_key: :title_image_id

  mount_uploader :image, PostImageUploader
end
