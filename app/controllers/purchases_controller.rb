class PurchasesController < ApplicationController
  before_action :set_client

  def create
    @purchase = @client.purchases.build(purchase_params)
    @purchase.employee = Current.employee
    @purchase.is_reward = false

    if @purchase.save
      redirect_to @client, notice: t("purchase.recorded")
    else
      redirect_to @client, alert: t("purchase.failed_to_record")
    end
  end

  def claim_reward
    unless @client.can_claim_reward?
      return redirect_to @client, alert: t("purchase.no_rewards_available")
    end

    @purchase = @client.purchases.build(
      employee: Current.employee,
      is_reward: true,
      note: "Free hookah reward"
    )

    if @purchase.save
      redirect_to @client, notice: t("purchase.reward_claimed")
    else
      redirect_to @client, alert: t("purchase.failed_to_claim")
    end
  end

  def destroy
    @purchase = @client.purchases.find(params[:id])

    unless @purchase.can_undo?
      return redirect_to @client, alert: t("purchase.cant_undo")
    end

    if @purchase.destroy
      redirect_to @client, notice: t("purchase.removed")
    else
      redirect_to @client, alert: t("purchase.failed_to_remove")
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
