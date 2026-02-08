namespace :admin do
  desc "Grant admin privileges to an employee (usage: bin/rails admin:grant[email@example.com])"
  task :grant, [:email] => :environment do |_t, args|
    unless args[:email]
      puts "Error: Email address is required."
      puts "Usage: bin/rails admin:grant[email@example.com]"
      exit 1
    end

    employee = Employee.find_by(email: args[:email])

    if employee
      employee.update!(admin: true)
      puts "Admin privileges granted to #{employee.name} (#{employee.email})"
    else
      puts "Error: Employee with email '#{args[:email]}' not found."
      exit 1
    end
  end

  desc "Revoke admin privileges from an employee (usage: bin/rails admin:revoke[email@example.com])"
  task :revoke, [:email] => :environment do |_t, args|
    unless args[:email]
      puts "Error: Email address is required."
      puts "Usage: bin/rails admin:revoke[email@example.com]"
      exit 1
    end

    employee = Employee.find_by(email: args[:email])

    if employee
      employee.update!(admin: false)
      puts "Admin privileges revoked from #{employee.name} (#{employee.email})"
    else
      puts "Error: Employee with email '#{args[:email]}' not found."
      exit 1
    end
  end
end
