class ImageStreamsController < ApplicationController
  helper_method :current_company
  before_filter :ensure_authenticated
  before_filter :redirect_to_company_stream, :unless => :authorized?

  def index
    @images = stream_source.images.newest.page(params[:page])
  end

  private

  def authorized?
    raise NotImplementedError.new("You must implement #authorized?.")
  end
end