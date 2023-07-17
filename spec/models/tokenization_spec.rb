require 'rails_helper'

RSpec.describe Tokenization, type: :model do
  it 'has encode method' do
    expect(Tokenization).to respond_to(:encode)
  end
  it 'encode method returns a string' do
    expect(Tokenization.encode('123')).to be_a_kind_of(String)
  end
  it 'has decode method' do
    expect(Tokenization).to respond_to(:decode)
  end
  it 'decode method returns a hash' do
    token = ''
    expect(Tokenization.decode(token)).to be_a_kind_of(Hash)
  end
  it 'decode must return a hash with the encoded data' do
    payload = {
      'test' => '123'
    }
    token = Tokenization.encode(payload)
    decoded_payload = Tokenization.decode(token)[:payload]

    expect(decoded_payload).to eq(payload)
  end
end
