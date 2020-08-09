# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: 'paratskiy',
             email: 'bog4242@gmail.com',
             password: '12345678-',
             password_confirmation: '12345678-')

99.times do |_n|
  name = FFaker::Name.name
  email = FFaker::Internet.unique.email
  password = FFaker::Internet.password
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
