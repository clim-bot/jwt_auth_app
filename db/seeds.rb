# db/seeds.rb

# Clear existing data
User.destroy_all

# Create a test user
User.create!(
  email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'
)

puts "Test user created: test@example.com / password"
