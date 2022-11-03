email = 'test@email.com'

User.where(
  name: 'Test User',
  email: email,
  password: '123456',
  password_confirmation: '123456'
).first_or_create!

puts "Test user with email '#{email}' created."
