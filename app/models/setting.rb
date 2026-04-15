class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.reward_threshold
    Rails.cache.fetch("setting:reward_threshold", expires_in: 1.hour) do
      threshold = Integer(find_by(key: "reward_threshold")&.value, exception: false)
      threshold&.positive? ? threshold : 5
    end
  end

  def self.lounge_name
    Rails.cache.fetch("setting:lounge_name", expires_in: 1.hour) do
      find_by(key: "lounge_name")&.value || "Hookah Lounge"
    end
  end
end
