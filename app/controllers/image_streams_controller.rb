class ImageStreamsController < ApplicationController
  helper_method :current_company
  before_filter :ensure_authenticated
  before_filter :ensure_authorized

  def index
    @images = stream_source.images.newest.page(params[:page])
  end

  private

  def ensure_authorized
    raise NotImplementedError.new("You must implement #ensure_authenticated.")
  end
end