# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
admin = User.create(
  name: 'Admin User', # Set the name of the admin user
  email: 'admin@stockpulse.com', # Set the email address
  password: 'password123', # Set a password
  password_confirmation: 'password123', # Confirm the password
  balance: 10000, # Set the initial balance (if needed)
  role: 'admin' # Set the role to 'admin'
)