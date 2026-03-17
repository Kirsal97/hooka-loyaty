require "test_helper"

module Admin
  class PurchasesControllerTest < ActionDispatch::IntegrationTest
    test "non-admin user is redirected away from index" do
      sign_in_as(employees(:one))
      get admin_purchases_path
      assert_redirected_to root_path
    end

    test "admin user can access index" do
      employee = employees(:one)
      employee.update!(admin: true)
      sign_in_as(employee)
      get admin_purchases_path
      assert_response :success
    end
  end
end
