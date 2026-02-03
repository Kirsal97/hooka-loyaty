class Client < ApplicationRecord
  has_many :purchases, dependent: :destroy

  validates :phone, presence: true, uniqueness: true
  validates :name, presence: true

  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }

  scope :search_by_phone, ->(phone) {
    where("phone LIKE ?", "%#{phone.gsub(/\D/, '')}%")
  }

  def paid_purchases_count
    purchases.where(is_reward: false).count
  end

  def claimed_rewards_count
    purchases.where(is_reward: true).count
  end

  def available_rewards
    paid_purchases_count / Setting.reward_threshold - claimed_rewards_count
  end

  def progress_to_next_reward
    paid_purchases_count % Setting.reward_threshold
  end

  def can_claim_reward?
    available_rewards > 0
  end
end
