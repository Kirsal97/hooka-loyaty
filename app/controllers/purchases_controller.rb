class PurchasesController < ApplicationController
  before_action :set_client

  def create
    @purchase = @client.purchases.build(purchase_params)
    @purchase.employee = Current.employee
    @purchase.is_reward = false

    if @purchase.save
      redirect_to @client, notice: "Purchase recorded"
    else
      redirect_to @client, alert: "Failed to record purchase"
    end
  end

  def claim_reward
    unless @client.can_claim_reward?
      return redirect_to @client, alert: "No rewards available"
    end

    @purchase = @client.purchases.build(
      employee: Current.employee,
      is_reward: true,
      note: "Free hookah reward"
    )

    if @purchase.save
      redirect_to @client, notice: "Reward claimed! Enjoy your free hookah"
    else
      redirect_to @client, alert: "Failed to claim reward"
    end
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def purchase_params
    params.require(:purchase).permit(:note)
  end
end
