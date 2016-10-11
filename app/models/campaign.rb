class Campaign < ActiveRecord::Base
  belongs_to :title_image, class_name: "PostImage"

  validates :title, presence: true
  validates :description, presence: true

end
