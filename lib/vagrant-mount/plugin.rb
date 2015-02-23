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
        require_relative 'commands/mount'
        Command::Mount
      end
      # VirtualBox
      require_relative 'actions/providers/virtualbox/mount'
      require_relative 'actions/providers/virtualbox/driver'

      # Hyper-V
      require_relative 'actions/providers/hyperv/mount'
      require_relative 'actions/providers/hyperv/driver'

      # VMWare Fusion
      begin
        require 'vagrant-vmware-fusion/action'
        require 'vagrant-vmware-fusion/driver'

        require_relative 'actions/provider/vmware-fusion/mount'
        require_relative 'actions/provider/vmware-fusion/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # VMWare Workstation
      begin
        require 'vagrant-vmware-workstation/action'
        require 'vagrant-vmware-workstation/driver'

        require_relative 'actions/provider/vmware-workstation/mount'
        require_relative 'actions/provider/vmware-workstation/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

      # Parallels Desktop
      begin
        require 'vagrant-parallels/action'
        require 'vagrant-parallels/driver'

        require_relative 'actions/provider/parallels/mount'
        require_relative 'actions/provider/parallels/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
      end

    end
  end
end
