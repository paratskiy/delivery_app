require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }
  TOO_LONG_EMAIL = "#{'a' * 255}@example.com".freeze
  TOO_LONG_NAME = ('a' * 51).to_s.freeze
  TOO_SHORT_PASS = ('a' * 5).to_s.freeze
  BLANK_PASS = (' ' * 7).to_s.freeze
  VALID_EMAILS = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                    first.last@foo.jp alice+bob@baz.cn].freeze
  INVALID_EMAILS = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com].freeze

  def build_custom_user(**params)
    FactoryBot.build(:user, params)
  end

  context 'correct user' do
    it 'should be valid' do
      expect(user).to be_valid
    end

    it 'should accept valid addresses' do
      VALID_EMAILS.each do |valid_email|
        expect(build_custom_user(email: valid_email)).to be_valid
      end
    end

    it 'email should be saved as lower-case' do
      VALID_EMAILS.each do |valid_email|
        user = build_custom_user(email: valid_email)
        user.save
        expect(user.email).to eq(valid_email.downcase)
      end
    end
  end

  context 'with empty data' do
    it 'is invalid without an email' do
      expect(build_custom_user(email: nil)).not_to be_valid
    end

    it 'is invalid without a name' do
      expect(build_custom_user(name: nil)).not_to be_valid
    end
  end

  context 'with duplicate data' do
    it 'has unique email' do
      expect(build_custom_user(email: user.email)).not_to be_valid
    end
  end

  context 'with incorrect data' do
    it 'name should not to be too long' do
      expect(build_custom_user(name: TOO_LONG_NAME)).not_to be_valid
    end

    it 'email should not to be too long' do
      expect(build_custom_user(email: TOO_LONG_EMAIL)).not_to be_valid
    end

    it 'password should not to be too short' do
      expect(build_custom_user(password: TOO_SHORT_PASS)).not_to be_valid
    end

    it 'password should not to be blank' do
      expect(build_custom_user(password: BLANK_PASS)).not_to be_valid
    end

    it 'should not accept invalid valid addresses' do
      INVALID_EMAILS.each do |invalid_email|
        expect(build_custom_user(email: invalid_email)).not_to be_valid
      end
    end
  end
end
