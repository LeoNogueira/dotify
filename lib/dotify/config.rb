require 'dotify'
require 'thor/util'
require 'yaml'

module Dotify
  class Config

    DOTIFY_DIRNAME = '.dotify'
    DOTIFY_BACKUP = '.backup'
    #SHELLS = {
    #  'zsh' => '/bin/zsh',
    #  'bash' => '/bin/bash',
    #  'sh' => '/bin/sh'
    #}

    class << self

      #def shell=(shell)
      #  if !SHELLS.keys.include?(shell)
      #    raise NonValidShell, "You must specify a valid shell: #{SHELLS.keys.map(&:inspect).join(", ")}"
      #  end
      #  @shell = shell
      #end

      #def shell
      #  @shell
      #end

      #def profile=(name)
      #  @profile = name
      #end

      #def profile
      #  @profile
      #end

      def dirname
        @dirname ||= DOTIFY_DIRNAME
      end

      def path
        File.join(home, dirname)
      end

      def backup
        File.join(path, backup_dirname)
      end

      def backup_dirname
        @backup ||= DOTIFY_BACKUP
      end

      def load_config!
        #@config = File.exists?(config_file) ? (YAML.load_file(config_file) || {}) : {}
        #symbolize_keys!(@config)
        #@config.each do |key, value|
        #  if !value.nil? && methods(false).map(&:to_s).include?("#{key}=")
        #    self.__send__("#{key}=", value)
        #  else
        #    @config.delete(key)
        #  end
        #end
        #@config
      end

      def config
        @config || load_config!
      end

      def home
        Thor::Util.user_home
      end

      private

        def config_file
          #File.join(home, '.dotrc')
        end

        def symbolize_keys!(opts)
          sym_opts = {}
          opts.each do |key, value|
            sym_opts[key.to_sym] = value.is_a?(Hash) ? symbolize_keys!(value) : value
          end
          sym_opts
        end

    end
  end
end
