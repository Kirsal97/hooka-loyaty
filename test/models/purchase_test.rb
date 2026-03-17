require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  def setup
    @client = clients(:john)
    @employee = employees(:one)
  end

  # Associations
  test "should belong to client" do
    purchase = purchases(:john_purchase_1)
    assert_respond_to purchase, :client
    assert_kind_of Client, purchase.client
  end

  test "should belong to employee" do
    purchase = purchases(:john_purchase_1)
    assert_respond_to purchase, :employee
    assert_kind_of Employee, purchase.employee
  end

  test "should be valid with valid attributes" do
    purchase = Purchase.new(
      client: @client,
      employee: @employee,
      is_reward: false
    )
    assert purchase.valid?
  end

  # Scope: paid
  test "paid scope should return only non-reward purchases" do
    paid = Purchase.paid
    assert paid.all? { |p| p.is_reward == false }
    assert_includes paid, purchases(:john_purchase_1)
    assert_not_includes paid, purchases(:john_reward_1)
  end

  test "paid scope should count correct number" do
    # Total paid purchases: 7 (john) + 3 (jane) = 10
    assert_equal 10, Purchase.paid.count
  end

  # Scope: rewards
  test "rewards scope should return only reward purchases" do
    rewards = Purchase.rewards
    assert rewards.all? { |p| p.is_reward == true }
    assert_includes rewards, purchases(:john_reward_1)
    assert_not_includes rewards, purchases(:john_purchase_1)
  end

  test "rewards scope should count correct number" do
    # Total rewards: 1 (john)
    assert_equal 1, Purchase.rewards.count
  end

  # Scope: recent
  test "recent scope should order by created_at descending" do
    purchases = Purchase.recent.limit(2)
    assert purchases.first.created_at >= purchases.second.created_at
  end

  test "recent scope should return all purchases in order" do
    all_purchases = Purchase.recent
    assert_equal Purchase.count, all_purchases.count

    # Verify ordering
    all_purchases.each_cons(2) do |current, previous|
      assert current.created_at >= previous.created_at
    end
  end

  # Scope combinations
  test "should be able to chain scopes" do
    # Get recent paid purchases
    recent_paid = Purchase.paid.recent
    assert recent_paid.all? { |p| p.is_reward == false }
    assert_equal Purchase.paid.count, recent_paid.count
  end

  test "should be able to scope by client" do
    # John's paid purchases
    johns_paid = @client.purchases.paid
    assert_equal 7, johns_paid.count

    # John's rewards
    johns_rewards = @client.purchases.rewards
    assert_equal 1, johns_rewards.count
  end

  # Creating purchases
  test "should create paid purchase" do
    assert_difference "Purchase.paid.count", 1 do
      Purchase.create!(
        client: @client,
        employee: @employee,
        is_reward: false,
        note: "Test purchase"
      )
    end
  end

  test "should create reward purchase" do
    assert_difference "Purchase.rewards.count", 1 do
      Purchase.create!(
        client: @client,
        employee: @employee,
        is_reward: true,
        note: "Test reward"
      )
    end
  end

  test "is_reward should default to false if not specified" do
    purchase = Purchase.create!(
      client: @client,
      employee: @employee
    )
    assert_equal false, purchase.is_reward
  end

  # can_undo?
  test "can_undo? returns true for recent purchase" do
    purchase = Purchase.create!(client: @client, employee: @employee, is_reward: false)
    assert purchase.can_undo?
  end

  test "can_undo? returns false after 5 minutes" do
    purchase = Purchase.create!(client: @client, employee: @employee, is_reward: false)
    travel 6.minutes do
      assert_not purchase.can_undo?
    end
  end

  test "can_undo? returns true at exactly 5 minutes" do
    purchase = Purchase.create!(client: @client, employee: @employee, is_reward: false)
    travel 5.minutes do
      assert purchase.can_undo?
    end
  end

  # Counter cache callbacks
  test "creating a paid purchase updates client paid_purchases_count" do
    bob = clients(:bob)
    assert_equal 0, bob.paid_purchases_count

    Purchase.create!(client: bob, employee: @employee, is_reward: false)
    assert_equal 1, bob.reload.paid_purchases_count
  end

  test "creating a reward purchase updates client reward_purchases_count" do
    bob = clients(:bob)
    assert_equal 0, bob.reload.reward_purchases_count

    Purchase.create!(client: bob, employee: @employee, is_reward: true)
    assert_equal 1, bob.reload.reward_purchases_count
  end

  test "destroying a purchase updates client counters" do
    bob = clients(:bob)
    purchase = Purchase.create!(client: bob, employee: @employee, is_reward: false)
    assert_equal 1, bob.reload.paid_purchases_count

    purchase.destroy
    assert_equal 0, bob.reload.paid_purchases_count
  end
end
