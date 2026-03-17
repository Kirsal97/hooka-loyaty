require "test_helper"

class LocaleControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(employees(:one))
  end

  test "update redirects back to referer" do
    patch locale_path, headers: { "HTTP_REFERER" => settings_url }
    assert_redirected_to settings_url
  end

  test "update redirects to root when no referer is present" do
    patch locale_path
    assert_redirected_to root_path
  end
end
