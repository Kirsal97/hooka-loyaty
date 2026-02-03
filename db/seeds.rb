Employee.find_or_create_by!(email_address: 'admin@example.com') do |employee|
  employee.password = 'password123'
  employee.name = 'Admin'
end

Setting.find_or_create_by!(key: 'reward_threshold') do |setting|
  setting.value = '5'
  setting.description = 'Purchases needed for free hookah'
end

Setting.find_or_create_by!(key: 'lounge_name') do |setting|
  setting.value = 'Hookah lounge'
  setting.description = 'Display name'
end

admin_employee = Employee.find_by(email_address: 'admin@example.com')

client1 = Client.find_or_create_by!(phone: '+1234567890') do |client|
  client.name = 'John Doe'
end

client2 = Client.find_or_create_by!(phone: '+1987654321') do |client|
  client.name = 'Jane Smith'
end

client3 = Client.find_or_create_by!(phone: '+1555555555') do |client|
  client.name = 'Bob Johnson'
end

3.times do |i|
  Purchase.create!(
    client: [ client1, client2, client3 ].sample,
    employee: admin_employee,
    is_reward: [ true, false ].sample,
    note: "Test purchase #{i + 1}"
  )
end
