require 'spec_helper'

RSpec.describe APIConfig do
  before do
    described_class::FILE = 'spec/config/api.yml'
    described_class.reload!
  end

  describe '.env' do
    it 'uses RAILS_ENV' do
      expect(ENV).to receive(:[]).with('RAILS_ENV').and_return('foo')

      expect(described_class.env).to eq('foo')
    end

    it 'uses RACK_ENV' do
      expect(ENV).to receive(:[]).with('RAILS_ENV').and_return(nil)
      expect(ENV).to receive(:[]).with('RACK_ENV').and_return('bars')

      expect(described_class.env).to eq('bars')
    end

    it 'defaults to development' do
      expect(ENV).to receive(:[]).with('RAILS_ENV').and_return(nil)
      expect(ENV).to receive(:[]).with('RACK_ENV').and_return(nil)

      expect(described_class.env).to eq('development')
    end
  end

  describe '.method_missing' do
    it 'works' do
      expect(described_class.env).to eq('development')

      expect(described_class.foo).to eq('foo')
      expect(described_class.bar).to eq('bar')
    end

    it 'gets the correct root key' do
      expect(described_class).to receive(:env).and_return('test')
      described_class.reload!

      expect(described_class.foo).to eq('bar')
      expect(described_class.bar).to eq(APIConfig::DeepStruct.new(baz: 'barbaz'))
    end
  end

  describe '.reload!' do
    it 'works' do
      foo = described_class.foo

      described_class::FILE = 'spec/config/foo.yml'

      expect(foo).to eq(described_class.foo)

      described_class.reload!

      expect(foo).not_to eq(described_class.foo)
    end
  end
end
