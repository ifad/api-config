require 'ostruct'
require 'yaml'

module APIConfig

  VERSION = '0.4.1'

  class << self
    def env
      ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def method_missing(m, *args, &block)
      if configuration.key?(m)
        # Get named configuration
        configuration.fetch(m)
      else
        # Get item from default configuration
        configuration_for(:default).public_send(m)
      end
    end

    def reload!(which = :default)
      if which == :all
        configuration.clear
        true
      else
        configuration.delete(which)
        configuration_for(which)
      end
    end

    def add_file(which, file)
      files[which] = file

      reload!(which)
    end
    alias set_file add_file

    def get_file(which)
      files[which]
    end

    protected
      def configuration
        @_configuration ||= {}
      end

      def files
        @_files ||= { default: 'config/api.yml' }
      end

      def configuration_for(which)
        configuration.fetch(which) do
          source = files.fetch(which)
          configuration[which] = parse(source)
        end
      end

      def parse(source)
        config = YAML.load_file(source).fetch(APIConfig.env)

        DeepStruct.new(config, source)

      rescue => e
        raise Error, "#{source}: #{e.message}"
      end
  end

  class Error < StandardError
  end

  class DeepStruct < OpenStruct
    def initialize(hash = nil, file = nil, parent = nil, branch = nil)
      @table      = {}
      @hash_table = {}
      @file       = file
      @parent     = parent
      @branch     = branch

      (hash || []).each do |k,v|
        @table[k.to_sym]      = (v.is_a?(Hash) ? self.class.new(v, file, self, k) : v)
        @hash_table[k.to_sym] = v

        new_ostruct_member(k)
      end
    end

    def each(&block)
      @table.each(&block)
    end

    def map(&block)
      @table.map(&block)
    end

    def to_h
      @hash_table
    end

    def path_for(key)
      [(@parent ? @parent.path_for(@branch) : APIConfig.env), key].compact.join('.')
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /\A(.+)!\Z/
        setting = $1.intern

        @table.fetch(setting) { raise Error, "API Setting `#{path_for(setting)}' not found in #{@file}" }
      else
        super
      end
    end

  end
end
