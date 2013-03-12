class CompanyImageStreamsController < ImageStreamsController

  private

  def stream_source
    current_company
  end

  def ensure_authorized
    if params[:company_slug] != current_company.slug
      redirect_to_company_stream
    end
  end
end