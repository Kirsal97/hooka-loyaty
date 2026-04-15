require "test_helper"

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
    sign_in_as(@employee)
  end

  # --- create ---

  test "create records a paid purchase and redirects to client" do
    client = clients(:jane)

    assert_difference "Purchase.count", 1 do
      post client_purchases_path(client), params: { purchase: { note: "Test visit" } }
    end

    assert_redirected_to client_path(client)
    assert_equal I18n.t("purchase.recorded"), flash[:notice]
  end

  test "create sets is_reward to false and assigns the current employee" do
    client = clients(:jane)

    post client_purchases_path(client), params: { purchase: { note: "Test visit" } }

    purchase = client.purchases.order(:created_at).last
    assert_equal false, purchase.is_reward
    assert_equal @employee, purchase.employee
  end

  # --- claim_reward ---

  test "claim_reward succeeds when the client has rewards available" do
    client = clients(:bob)

    # Give bob 5 paid purchases so he has 1 available reward.
    5.times { client.purchases.create!(employee: @employee, is_reward: false) }
    client.reload

    assert_difference "Purchase.count", 1 do
      post claim_reward_client_purchases_path(client)
    end

    assert_redirected_to client_path(client)
    assert_equal I18n.t("purchase.reward_claimed"), flash[:notice]

    reward = client.purchases.rewards.order(:created_at).last
    assert reward.is_reward
    assert_equal @employee, reward.employee
  end

  test "claim_reward redirects with alert when no rewards are available" do
    client = clients(:jane) # 3 paid purchases, threshold is 5 -> 0 available rewards

    assert_no_difference "Purchase.count" do
      post claim_reward_client_purchases_path(client)
    end

    assert_redirected_to client_path(client)
    assert_equal I18n.t("purchase.no_rewards_available"), flash[:alert]
  end

  # --- destroy ---

  test "destroy removes a recent purchase and redirects to client" do
    client = clients(:jane)
    purchase = client.purchases.create!(employee: @employee, is_reward: false, note: "Fresh visit")

    assert_difference "Purchase.count", -1 do
      delete client_purchase_path(client, purchase)
    end

    assert_redirected_to client_path(client)
    assert_equal I18n.t("purchase.removed"), flash[:notice]
  end

  test "destroy rejects undo for a purchase older than 5 minutes" do
    client = clients(:jane)
    purchase = client.purchases.create!(employee: @employee, is_reward: false, note: "Old visit")

    travel 6.minutes do
      assert_no_difference "Purchase.count" do
        delete client_purchase_path(client, purchase)
      end

      assert_redirected_to client_path(client)
      assert_equal I18n.t("purchase.cant_undo"), flash[:alert]
    end
  end

  # --- authentication ---

  test "unauthenticated user is redirected to the sign-in page" do
    sign_out

    post client_purchases_path(clients(:jane)), params: { purchase: { note: "Sneaky" } }

    assert_redirected_to new_session_path
  end
end
