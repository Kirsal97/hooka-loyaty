class Purchase < ApplicationRecord
  belongs_to :client
  belongs_to :employee

  scope :paid, -> { where(is_reward: false) }
  scope :rewards, -> { where(is_reward: true) }
  scope :recent, -> { order(created_at: :desc) }
end
