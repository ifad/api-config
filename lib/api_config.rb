require 'ostruct'
require 'yaml'

module APIConfig

  VERSION = '0.3.3'
  FILE    = { default: 'config/api.yml' }

  class Error < StandardError
  end

  class << self
    def env
      ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def method_missing(m, *args, &block)
      configuration(:default).public_send(m) || configuration(m)
    end

    def reload! which = :default
      which = which.to_sym

      if which == :all
        @configuration = nil
      else
        defined?(@configuration) && @configuration.public_send("#{which}=", nil)
      end

      configuration which
    end

    def set_file file = 'config/api.yml', which = :default
      which = which.to_sym

      FILE[which] = file

      reload! which
    end
    alias add_file set_file

    protected
      def configuration which = :default
        which = which.to_sym

        @configuration ||= DeepStruct.new

        if _c = @configuration.public_send(which)
          _c
        else
          file = FILE[which]

          @configuration.public_send("#{which}=", DeepStruct.new(YAML.load_file(file).fetch(APIConfig.env), file))
        end
      end
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
