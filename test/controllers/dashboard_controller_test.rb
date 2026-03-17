require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(employees(:one))
  end

  test "index renders successfully" do
    get root_path
    assert_response :success
  end

  test "index with phone search param returns results" do
    get root_path, params: { phone: clients(:john).phone }
    assert_response :success
  end

  test "unauthenticated access redirects to sign in" do
    sign_out
    get root_path
    assert_redirected_to new_session_path
  end
end
