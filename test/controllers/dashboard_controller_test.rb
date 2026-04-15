require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(employees(:one))
    @john = clients(:john)
  end

  test "index renders successfully" do
    get root_path
    assert_response :success
  end

  test "index with phone search param returns matching clients" do
    get root_path, params: { phone: "1234567" }

    assert_response :success
    assert_select "h6", text: @john.name
    assert_select "h6", text: clients(:jane).name, count: 0
  end

  test "turbo frame search renders only the search results partial" do
    get root_path, params: { phone: @john.phone }, headers: { "Turbo-Frame" => "search_results" }

    assert_response :success
    assert_not_includes response.body, "<html"
    assert_select "turbo-frame#search_results"
    assert_select "h6", text: @john.name
  end

  test "unauthenticated access redirects to sign in" do
    sign_out
    get root_path
    assert_redirected_to new_session_path
  end
end
