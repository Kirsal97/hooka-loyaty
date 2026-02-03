class DashboardController < ApplicationController
  def index
    @query = params[:phone]

    if @query.present?
      @clients = Client.search_by_phone(@query).limit(20)
    else
      @clients = Client.order(created_at: :desc).limit(10)
    end

    # Render only the results partial for Turbo Frame requests
    if turbo_frame_request?
      render partial: "search_results", locals: { clients: @clients, query: @query }
    end
  end
end
