require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#token data' do
    let(:user) { described_class.create(username: 'RSpecUserTest') }
    it 'has method' do
      expect(user).to respond_to(:token_data)
    end
    subject(:token_data) { user.token_data }
    it 'responds a hash' do
      expect(token_data).to be_a_kind_of(Hash)
    end
    it 'responds a hash with the id and the username' do
      expect(token_data).to include(user_id: user.id, username: user.username)
    end
  end
end
