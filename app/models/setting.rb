class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.reward_threshold
    find_by(key: "reward_threshold")&.value&.to_i || 5
  end

  def self.lounge_name
    find_by(key: "lounge_name")&.value || "Hookah Lounge"
  end
end
