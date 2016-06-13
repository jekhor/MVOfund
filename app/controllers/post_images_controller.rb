class PostImagesController < ApplicationController

  def index
    @images = PostImage.all

    render :json => @images.map {|i| {url: i.image.url, thumb: i.image.thumb.url}}
  end

  def upload
    image = PostImage.new
    image.image = params[:file]

    if image.save
      render :json => {link: image.image.url}
    else
      render :json => {error: 'Failed to save image'}, status: 500
    end
  end
end
