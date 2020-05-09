require 'ffaker'

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
  end
end
