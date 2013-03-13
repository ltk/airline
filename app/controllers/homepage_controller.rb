class HomepageController < ApplicationController
  before_filter :redirect_authenticated_users

  def show
  end

  private

  def redirect_authenticated_users
    redirect_to_company_stream if current_user
  end
end
