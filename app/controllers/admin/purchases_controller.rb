module Admin
  class PurchasesController < ApplicationController
    before_action :require_admin

    def index
      @per_page = 30
      @offset = [ params[:offset].to_i, 0 ].max

      @purchases = Purchase.recent.includes(:client, :employee)

      if params[:type].present?
        @purchases = @purchases.where(is_reward: params[:type] == "reward")
      end

      if params[:search].present?
        @purchases = @purchases.joins(:client).where("clients.phone LIKE ?", "%#{params[:search]}%")
      end

      @purchases = @purchases.limit(@per_page + 1).offset(@offset).to_a
      @has_more = @purchases.size > @per_page
      @purchases = @purchases.first(@per_page)
    end
  end
end
