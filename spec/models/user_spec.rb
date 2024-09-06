require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid without a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid if password and password_confirmation do not match' do
      subject.password_confirmation = 'different_password'
      expect(subject).not_to be_valid
    end

    it 'is invalid with a short password' do
      subject.password = '123'
      subject.password_confirmation = '123'
      expect(subject).not_to be_valid
    end
  end

  describe 'Uniqueness' do
    it 'does not allow duplicate email addresses' do
      User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      duplicate_user = User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(duplicate_user).not_to be_valid
    end
  end
end
