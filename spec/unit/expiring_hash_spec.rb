require 'spec_helper'

describe ExpiringHash do
  let(:default_hash) { ExpiringHash.new }

  it 'is a Hash' do
    expect(default_hash).to be_a(Hash)
  end

  it 'looks like a regular hash' do
    default_hash[:asdf] = 1
    expect(default_hash).to eq({:asdf => 1})
  end

  it 'stores and retrieves values like a hash' do
    default_hash[:asdf] = 1
    expect(default_hash[:asdf]).to be(1)
  end

  it 'delete_if works the same' do
    default_hash[:asdf] = 1
    default_hash[:qwer] = 2

    default_hash.delete_if {|k,v| v == 1}
    expect(default_hash).to eq({:qwer => 2})
  end

  describe 'expiration' do
    it 'expires values after its lifetime' do
      fake_time = class_double(Time)
      expiring = ExpiringHash.new(nil, :lifetime => 10, :time_impl => fake_time)

      expect(fake_time).to receive(:now).and_return(0, 5, 15)

      expiring[:some_key] = 1

      expect(expiring[:some_key]).to be(1)
      expect(expiring[:some_key]).to be_nil
      expect(expiring).to eq({})
    end
  end
end
