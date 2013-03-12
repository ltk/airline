class UserImageStreamsController < ImageStreamsController

  private

  def stream_source
    @user ||= current_company.users.find_by_slug(params[:user_slug])
  end

  def ensure_authorized
    if params[:user_slug].present? && !current_user.coworker_of?(stream_source)
      redirect_to_company_stream
    end
  end
end