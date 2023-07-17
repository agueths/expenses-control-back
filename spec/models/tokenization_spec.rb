require 'rails_helper'

RSpec.describe Tokenization, type: :model do
  let(:payload) { { 'test' => '123' } }

  describe '.encode' do
    it 'has method' do
      expect(Tokenization).to respond_to(:encode)
    end
    it 'returns a string' do
      expect(Tokenization.encode(payload)).to be_a_kind_of(String)
    end
  end

  describe '.decode' do
    it 'has method' do
      expect(Tokenization).to respond_to(:decode)
    end
    it 'returns a hash' do
      token = ''
      expect(Tokenization.decode(token)).to be_a_kind_of(Hash)
    end
    it 'must return a hash with the encoded data' do
      token = Tokenization.encode(payload)
      decoded_payload = Tokenization.decode(token)[:payload]

      expect(decoded_payload).to eq(payload)
    end
  end
end
