# frozen_string_literal: true

require 'spec_helper'

RSpec.describe APIConfig do
  before do
    described_class.set_file(:default, 'spec/config/api.yml')
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

  describe '.env=' do
    before do
      described_class.env = 'foobarbaz'
      @old_rails_env = ENV.fetch('RAILS_ENV', nil)
      @old_rack_env = ENV.fetch('RACK_ENV', nil)
    end

    after do
      described_class.env = nil
      ENV['RAILS_ENV'] = @old_rails_env
      ENV['RACK_ENV'] = @old_rack_env
    end

    it 'uses defined environment value' do
      expect(described_class.env).to eq('foobarbaz')
    end

    it 'uses defined environment value even if RAILS_ENV is set' do
      ENV['RAILS_ENV'] = 'foo'

      expect(described_class.env).to eq('foobarbaz')
    end

    it 'uses defined environment value even if RACK_ENV is set' do
      ENV['RAILS_ENV'] = nil
      ENV['RACK_ENV'] = 'bar'

      expect(described_class.env).to eq('foobarbaz')
    end
  end

  describe '.method_missing' do
    it 'works' do
      expect(described_class.foo).to eq('foo')
      expect(described_class.bar).to eq('bar')
    end

    it 'gets the correct root key' do
      expect(described_class).to receive(:env).and_return('foobarbaz')
      described_class.reload!

      expect(described_class.foo).to eq('bar')
      expect(described_class.bar).to eq(APIConfig::DeepStruct.new(baz: 'barbaz'))
    end
  end

  describe '.reload!' do
    it 'works' do
      foo = described_class.foo

      described_class.set_file :default, 'spec/config/foo.yml'

      expect(foo).not_to eq(described_class.foo)
    end
  end

  describe '.set_file' do
    it 'works' do
      file = described_class.get_file(:default)

      described_class.set_file :default, 'spec/config/foo.yml'

      expect(file).not_to eq(described_class.get_file(:default))
    end
  end
end
