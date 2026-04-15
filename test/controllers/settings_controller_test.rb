require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(employees(:one))
  end

  test "index renders successfully" do
    get settings_path
    assert_response :success
  end

  test "update with valid reward threshold" do
    patch setting_path("reward_threshold"), params: { key: "reward_threshold", value: "10", description: "Updated threshold" }
    assert_redirected_to settings_path
    assert_equal I18n.t("settings.updated"), flash[:notice]
    assert_equal "10", Setting.find_by(key: "reward_threshold").value
  end

  test "update rejects reward threshold less than 1" do
    patch setting_path("reward_threshold"), params: { key: "reward_threshold", value: "0", description: "" }
    assert_redirected_to settings_path
    assert_equal I18n.t("settings.threshold_too_low"), flash[:alert]
    assert_equal "5", Setting.find_by(key: "reward_threshold").value
  end

  test "update rejects blank reward threshold" do
    patch setting_path("reward_threshold"), params: { key: "reward_threshold", value: "", description: "" }
    assert_redirected_to settings_path
    assert_equal I18n.t("settings.threshold_too_low"), flash[:alert]
    assert_equal "5", Setting.find_by(key: "reward_threshold").value
  end

  test "update lounge_name" do
    patch setting_path("lounge_name"), params: { key: "lounge_name", value: "New Lounge Name", description: "Updated name" }
    assert_redirected_to settings_path
    assert_equal I18n.t("settings.updated"), flash[:notice]
    assert_equal "New Lounge Name", Setting.find_by(key: "lounge_name").value
  end
end
