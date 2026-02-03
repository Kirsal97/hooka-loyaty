class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :employee, to: :session, allow_nil: true
end
