class UserImageStreamsController < ImageStreamsController

  private

  def stream_source
    @user ||= current_company.users.find_by_slug(params[:user_slug])
  end

  def authorized?
    stream_source && stream_source.company == current_company
  end
end