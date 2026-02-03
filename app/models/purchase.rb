class Purchase < ApplicationRecord
  belongs_to :client, counter_cache: true
  belongs_to :employee

  scope :paid, -> { where(is_reward: false) }
  scope :rewards, -> { where(is_reward: true) }
  scope :recent, -> { order(created_at: :desc) }

  after_save :update_purchase_counters
  after_destroy :update_purchase_counters

  def can_undo?
    created_at >= 5.minutes.ago
  end

  private

  def update_purchase_counters
    client.update_columns(
      paid_purchases_count: client.purchases.paid.count,
      reward_purchases_count: client.purchases.rewards.count
    )
  end
end
