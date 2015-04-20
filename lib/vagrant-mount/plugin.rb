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
#      @logger.info "Loading command :mount"
      command(:mount) do
        require_relative 'commands/mount'
        Command::Mount
      end

#      @logger.info "Loading command :unmount"
      command(:unmount) do
        require_relative 'commands/unmount'
        Command::Unmount
      end

      # VirtualBox
      begin
        require_relative 'actions/providers/virtualbox/action'
        require_relative 'actions/providers/virtualbox/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # Hyper-V
      begin
        require_relative 'actions/providers/hyperv/mount'
        require_relative 'actions/providers/hyperv/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # VMWare Fusion
      begin
        require 'vagrant-vmware-fusion/action'
        require 'vagrant-vmware-fusion/driver'

        require_relative 'actions/providers/vmware-fusion/action'
        require_relative 'actions/providers/vmware-fusion/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # VMWare Workstation
      begin
        require 'vagrant-vmware-workstation/action'
        require 'vagrant-vmware-workstation/driver'

        require_relative 'actions/providers/vmware-workstation/mount'
        require_relative 'actions/providers/vmware-workstation/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # Parallels Desktop
      begin
        require 'vagrant-parallels/action'
        require 'vagrant-parallels/driver'

        require_relative 'actions/providers/parallels/mount'
        require_relative 'actions/providers/parallels/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end
    end
  end
end
