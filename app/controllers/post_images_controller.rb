class PostImagesController < ApplicationController
# TODO: make uplaods working with authorization
#  before_action :authenticate_user!, only: [:upload]

  def index
    @images = PostImage.all

#    render :json => @images.map {|i| {url: i.image.url, thumb: i.image.thumb.url}}
  end

  def upload
    image = PostImage.new
    image.image = params[:file]

    if image.save
      render :json => {location: image.image.url}
    else
      render :json => {error: 'Failed to save image'}, status: 500
    end
  end
end
