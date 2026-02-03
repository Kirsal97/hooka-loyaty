class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :edit, :update ]

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client, notice: "Client added successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @per_page = 20
    @offset = [ params[:offset].to_i, 0 ].max
    @purchases = @client.purchases.recent.includes(:employee).limit(@per_page).offset(@offset)
    @has_more = @client.purchases_count.to_i > (@offset + @per_page)
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :phone)
  end
end
