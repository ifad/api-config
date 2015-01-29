require 'ostruct'
require 'yaml'

module APIConfig

  VERSION = '0.0.1'

  class << self
    def env
      ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def method_missing(m, *args, &block)
      configuration.send(m)
    rescue
      nil
    end

    protected
      def configuration
        @configuration ||= DeepStruct.new YAML.load_file('config/api.yml').fetch(APIConfig.env)
      end
  end

  class DeepStruct < OpenStruct
    def initialize(hash=nil)
      @table      = {}
      @hash_table = {}

      (hash || []).each do |k,v|
        @table[k.to_sym]      = (v.is_a?(Hash) ? self.class.new(v) : v)
        @hash_table[k.to_sym] = v

        new_ostruct_member(k)
      end
    end

    def to_h
      @hash_table
    end

  end
end
