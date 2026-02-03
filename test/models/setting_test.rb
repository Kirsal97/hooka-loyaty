require "test_helper"

class SettingTest < ActiveSupport::TestCase
  # Validations
  test "should be valid with valid attributes" do
    setting = Setting.new(key: "test_key", value: "test_value")
    assert setting.valid?
  end

  test "should require key" do
    setting = Setting.new(value: "test_value")
    assert_not setting.valid?
    assert_includes setting.errors[:key], "can't be blank"
  end

  test "should require unique key" do
    setting = Setting.new(key: "reward_threshold", value: "10")
    assert_not setting.valid?
    assert_includes setting.errors[:key], "has already been taken"
  end

  # Class method: reward_threshold
  test "reward_threshold should return value from database" do
    assert_equal 5, Setting.reward_threshold
  end

  test "reward_threshold should return default when not found" do
    Setting.find_by(key: "reward_threshold").destroy
    assert_equal 5, Setting.reward_threshold
  end

  test "reward_threshold should convert string to integer" do
    setting = Setting.find_by(key: "reward_threshold")
    setting.update!(value: "10")
    assert_equal 10, Setting.reward_threshold
    assert_kind_of Integer, Setting.reward_threshold
  end

  test "reward_threshold should handle empty string as zero" do
    setting = Setting.find_by(key: "reward_threshold")
    setting.update!(value: "")
    # Empty string converts to 0 with to_i
    assert_equal 0, Setting.reward_threshold
  end

  # Class method: lounge_name
  test "lounge_name should return value from database" do
    assert_equal "Paradise Hookah Lounge", Setting.lounge_name
  end

  test "lounge_name should return default when not found" do
    Setting.find_by(key: "lounge_name").destroy
    assert_equal "Hookah Lounge", Setting.lounge_name
  end

  test "lounge_name should return string value" do
    setting = Setting.find_by(key: "lounge_name")
    setting.update!(value: "My Custom Lounge")
    assert_equal "My Custom Lounge", Setting.lounge_name
    assert_kind_of String, Setting.lounge_name
  end
end
