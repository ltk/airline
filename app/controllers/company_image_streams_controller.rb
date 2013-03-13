class CompanyImageStreamsController < ImageStreamsController

  private

  def stream_source
    current_company
  end

  def authorized?
    params[:company_slug] == current_company.slug
  end
end