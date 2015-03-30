require 'vagrant-mount/version'
require 'vagrant-mount/plugin'

module VagrantPlugins
  module Mount
    lib_path = Pathname.new(File.expand_path('../vagrant-mount', __FILE__))
    autoload :Errors, lib_path.join('errors')

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    Dir.glob('locales/*.yml').each do |lang|
      I18n.load_path << File.expand_path(lang)
    end
    I18n.reload!
  end
end
