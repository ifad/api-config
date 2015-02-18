require 'ostruct'
require 'yaml'

module APIConfig

  VERSION = '0.1.0'
  FILE    = 'config/api.yml'

  class Error < StandardError
  end

  class << self
    def env
      ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def method_missing(m, *args, &block)
      configuration.send(m)
    end

    protected
      def configuration
        @configuration ||= DeepStruct.new YAML.load_file(FILE).fetch(APIConfig.env)
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

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /\A(.+)!\Z/
        setting = $1.intern
        @table.fetch(setting) { raise Error, "API Setting `#{setting}' not found in #{FILE}" }
      else
        super
      end
    end

  end
end
