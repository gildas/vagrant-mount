begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Mount plugin must be run within Vagrant.'
end

raise 'The Vagrant Mount plugin is only compatible with Vagrant 1.2+' if Vagrant::VERSION < '1.2.0'

module VagrantPlugins
  module Mount
    class Plugin < Vagrant.plugin('2')
      name 'mount'
      description <<-DESC
      This plugin mount ISO files inside Virtual Machines as DVD/CD
      DESC

      command(:mount) do
        require_relative 'command_mount'
        Command::Mount
      end
    end
  end
end
