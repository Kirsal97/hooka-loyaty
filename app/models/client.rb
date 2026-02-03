class Client < ApplicationRecord
  has_many :purchases, dependent: :destroy

  validates :phone, presence: true, uniqueness: true
  validates :name, presence: true

  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }

  scope :search_by_phone, ->(phone) {
    where("phone LIKE ?", "%#{phone.gsub(/\D/, '')}%")
  }

  def formatted_phone
    return phone if phone.blank?

    digits = phone.gsub(/\D/, "")
    return phone if digits.length != 10

    digits.gsub(/(\d{3})(\d{3})(\d{4})/, '(\1) \2-\3')
  end

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
