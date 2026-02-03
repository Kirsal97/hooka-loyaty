require "test_helper"

class ClientTest < ActiveSupport::TestCase
  def setup
    @john = clients(:john)
    @jane = clients(:jane)
    @bob = clients(:bob)
  end

  # Validations
  test "should be valid with valid attributes" do
    client = Client.new(name: "Test User", phone: "1234567890")
    assert client.valid?
  end

  test "should require name" do
    client = Client.new(phone: "1234567890")
    assert_not client.valid?
    assert_includes client.errors[:name], "can't be blank"
  end

  test "should require phone" do
    client = Client.new(name: "Test User")
    assert_not client.valid?
    assert_includes client.errors[:phone], "can't be blank"
  end

  test "should require unique phone" do
    # Create a client with a phone that normalizes to the same as John's
    client = Client.new(name: "Another User", phone: "(555) 123-4567")
    assert_not client.valid?
    assert_includes client.errors[:phone], "has already been taken"
  end

  # Phone normalization
  test "should normalize phone by removing non-digit characters" do
    client = Client.create!(name: "Test User", phone: "(555) 999-8888")
    assert_equal "5559998888", client.phone
  end

  test "should normalize phone with spaces and dashes" do
    client = Client.create!(name: "Test User", phone: "555 777 6666")
    assert_equal "5557776666", client.phone
  end

  # Search scope
  test "should find client by partial phone number" do
    results = Client.search_by_phone("555123")
    assert_includes results, @john
  end

  test "should find client by phone with special characters" do
    results = Client.search_by_phone("(555) 123")
    assert_includes results, @john
  end

  test "should not find client with non-matching phone" do
    results = Client.search_by_phone("999999")
    assert_not_includes results, @john
  end

  # Association
  test "should have many purchases" do
    assert_respond_to @john, :purchases
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @john.purchases
  end

  test "should destroy associated purchases when client is destroyed" do
    purchase_count = @john.purchases.count
    assert purchase_count > 0

    assert_difference "Purchase.count", -purchase_count do
      @john.destroy
    end
  end

  # Reward calculation methods
  test "paid_purchases_count should count only non-reward purchases" do
    # John has 7 paid purchases
    assert_equal 7, @john.paid_purchases_count

    # Jane has 3 paid purchases
    assert_equal 3, @jane.paid_purchases_count
  end

  test "claimed_rewards_count should count only reward purchases" do
    # John has 1 claimed reward
    assert_equal 1, @john.claimed_rewards_count

    # Jane has 0 claimed rewards
    assert_equal 0, @jane.claimed_rewards_count
  end

  test "available_rewards should calculate correctly" do
    # John: 7 paid / 5 threshold = 1 earned, 1 claimed = 0 available
    assert_equal 0, @john.available_rewards

    # Jane: 3 paid / 5 threshold = 0 earned, 0 claimed = 0 available
    assert_equal 0, @jane.available_rewards
  end

  test "available_rewards should be correct after reaching threshold" do
    # Bob has no purchases
    bob = @bob

    # Add 5 paid purchases
    5.times do
      bob.purchases.create!(employee: employees(:one), is_reward: false)
    end

    # Bob should have 1 available reward (5/5 - 0)
    assert_equal 1, bob.available_rewards
  end

  test "available_rewards should account for claimed rewards" do
    bob = @bob

    # Add 10 paid purchases
    10.times do
      bob.purchases.create!(employee: employees(:one), is_reward: false)
    end

    # Add 1 claimed reward
    bob.purchases.create!(employee: employees(:one), is_reward: true)

    # Bob should have 1 available reward (10/5 - 1 = 2 - 1 = 1)
    assert_equal 1, bob.available_rewards
  end

  test "progress_to_next_reward should calculate remainder" do
    # John: 7 % 5 = 2
    assert_equal 2, @john.progress_to_next_reward

    # Jane: 3 % 5 = 3
    assert_equal 3, @jane.progress_to_next_reward
  end

  test "progress_to_next_reward should be 0 at threshold" do
    bob = @bob

    # Add exactly 5 paid purchases
    5.times do
      bob.purchases.create!(employee: employees(:one), is_reward: false)
    end

    assert_equal 0, bob.progress_to_next_reward
  end

  test "can_claim_reward? should return true when rewards available" do
    bob = @bob

    # Add 5 paid purchases to earn a reward
    5.times do
      bob.purchases.create!(employee: employees(:one), is_reward: false)
    end

    assert bob.can_claim_reward?
  end

  test "can_claim_reward? should return false when no rewards available" do
    # Jane has 3 paid purchases (not enough for a reward)
    assert_not @jane.can_claim_reward?

    # John has earned rewards but already claimed them
    assert_not @john.can_claim_reward?
  end
end
