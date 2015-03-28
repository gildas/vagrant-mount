require 'logger'
require 'vagrant-mount/version'
require 'vagrant-mount/plugin'

module VagrantPlugins
  module Mount
    lib_path = Pathname.new(File.expand_path('../vagrant-mount', __FILE__))
    autoload :Errors, lib_path.join('errors')

    def self.logger
      @logger ||= Logger.new(File.open('vagrant_plugins_mount.log', 'a'))
    end

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    Dir.glob('locales/*.yml').each do |lang|
      self.logger.info "Loading localization from #{lang}"
      I18n.load_path << File.expand_path(lang)
    end
    I18n.reload!
  end
end
