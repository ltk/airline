class UserImageStreamsController < ImageStreamsController

  private

  def stream_source
    @user ||= current_company.users.find_by_slug(params[:user_slug])
  end

  def ensure_authorized
    if stream_source.nil? || stream_source.company != current_company
      redirect_to_company_stream
    end
  end
end