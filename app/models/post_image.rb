class PostImage < ActiveRecord::Base
  has_many :campaigns, inverse_of: :title_image, dependent: :nullify

  mount_uploader :image, PostImageUploader
end
