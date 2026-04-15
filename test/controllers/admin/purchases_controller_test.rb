require "test_helper"

module Admin
  class PurchasesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin = employees(:one)
      @admin.update!(admin: true)
    end

    test "non-admin user is redirected away from index" do
      sign_in_as(employees(:two))
      get admin_purchases_path

      assert_redirected_to root_path
      assert_equal I18n.t("authorization.not_authorized"), flash[:alert]
    end

    test "admin user can access index" do
      sign_in_as(@admin)

      get admin_purchases_path

      assert_response :success
      assert_select "h1", text: I18n.t("admin.purchases.title")
    end

    test "admin can filter reward purchases" do
      sign_in_as(@admin)
      client = clients(:bob)

      client.purchases.create!(employee: @admin, is_reward: false, note: "Admin paid purchase")
      client.purchases.create!(employee: @admin, is_reward: true, note: "Admin reward purchase")

      get admin_purchases_path, params: { search: client.phone, type: "reward" }

      assert_response :success
      assert_select "tbody tr", 1
      assert_includes response.body, "Admin reward purchase"
      assert_not_includes response.body, "Admin paid purchase"
    end

    test "admin can search purchases by phone" do
      sign_in_as(@admin)

      get admin_purchases_path, params: { search: "1234567" }

      assert_response :success
      assert_includes response.body, "John Doe"
      assert_not_includes response.body, "Jane Smith"
    end

    test "admin purchases are ordered newest first" do
      sign_in_as(@admin)
      client = clients(:bob)

      client.purchases.create!(employee: @admin, is_reward: false, note: "Older admin purchase", created_at: 2.days.ago)
      client.purchases.create!(employee: @admin, is_reward: false, note: "Newer admin purchase", created_at: 1.day.ago)

      get admin_purchases_path, params: { search: client.phone }

      assert_response :success
      assert_operator response.body.index("Newer admin purchase"), :<, response.body.index("Older admin purchase")
    end

    test "admin purchases paginate with offset" do
      sign_in_as(@admin)
      client = clients(:bob)

      31.times do |index|
        client.purchases.create!(employee: @admin, is_reward: false, note: "Paged purchase #{index}", created_at: index.minutes.ago)
      end

      get admin_purchases_path, params: { search: client.phone }

      assert_response :success
      assert_select "tbody tr", 30
      assert_includes response.body, "Paged purchase 0"
      assert_not_includes response.body, "Paged purchase 30"
      assert_includes response.body, I18n.t("admin.purchases.load_more")

      get admin_purchases_path, params: { search: client.phone, offset: 30 }

      assert_response :success
      assert_select "tbody tr", 1
      assert_includes response.body, "Paged purchase 30"
      assert_not_includes response.body, I18n.t("admin.purchases.load_more")
    end
  end
end
