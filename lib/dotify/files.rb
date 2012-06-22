require 'dotify/config'
require 'thor/actions'
require 'thor/shell'

Dotify::Config.load_config!

module Dotify
  class Files
    class << self
      include Thor::Shell
      include Thor::Actions

      def dots
        @dots ||= file_list("#{dotify_path}/.*")
        return @dots unless block_given?
        @dots.each {|d| yield(d) }
      end

      def installed
        dots = self.dots.map { |f| file_name(f) }
        installed = file_list("#{home}/.*").select do |i|
          dots.include?(file_name(i))
        end
        return installed unless block_given?
        installed.each {|i| yield(i) }
      end

      def templates
        @templates ||= self.dots.select { |f| file_name(f) =~ /\.erb$/ }
        return @templates unless block_given?
        @templates.each {|i| yield(i) }
      end

      def file_name(file)
        file.split("/").last
      end

      def template?(file)
        file_name(file).match(/(tt|erb)$/) ? true : false
      end

      def link_dotfile(file)
        FileUtils.ln_s(file_name(file), home) == 0 ? true : false
      end

      def unlink_dotfile(file)
        FileUtils.rm_rf File.join(home, file_name(file))
      end

      private

        def file_list(dir_glob)
          filter_dot_directories!(Dir[dir_glob])
        end

        def filter_dot_directories!(files)
          files.select { |f| !['.', '..'].include?(file_name(f)) }
        end

        def home
          Config.home
        end

        def dotify_path
          Config.path
        end

    end
  end
end
