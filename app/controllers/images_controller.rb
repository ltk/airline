class ImagesController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :set_company, :only => :index

  def create
    @image = Image.new(params[:image])
    @image.user = current_user
    @image.company = current_user.company if current_user.company
    @image.save
  end

  def index
    @images = @current_company.images.order("created_at DESC").page(params[:page]).per_page(25)
  end

  private

  def set_company
    @current_company = current_user.company if current_user.company.present?
  end
end
