require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    employee = Employee.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", employee.email_address)
  end

  test "authenticates with correct password" do
    employee = employees(:one)
    assert employee.authenticate("password")
  end

  test "rejects wrong password" do
    employee = employees(:one)
    assert_not employee.authenticate("wrong")
  end

  test "has many sessions" do
    employee = employees(:one)
    assert_respond_to employee, :sessions
    assert_kind_of ActiveRecord::Associations::CollectionProxy, employee.sessions
  end

  test "destroys sessions when destroyed" do
    employee = Employee.create!(email_address: "disposable@example.com", password: "password")
    employee.sessions.create!

    assert_difference "Session.count", -1 do
      employee.destroy
    end
  end
end
