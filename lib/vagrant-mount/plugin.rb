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
        STDERR.puts "Vagrant plugin Virtualbox not available, ignoring code\n  Error: #{$!}"
      end

      # Hyper-V
      begin
        require_relative 'actions/providers/hyperv/mount'
        require_relative 'actions/providers/hyperv/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
        STDERR.puts "Vagrant plugin Hyper-V not available, ignoring code\n  Error: #{$!}"
      end

      # VMWare Fusion
      begin
        require 'vagrant-vmware-fusion/action'
        require 'vagrant-vmware-fusion/driver'

        require_relative 'actions/provider/vmware-fusion/mount'
        require_relative 'actions/provider/vmware-fusion/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
        STDERR.puts "Vagrant plugin VMWare Fusion not available, ignoring code\n  Error: #{$!}"
      end

      # VMWare Workstation
      begin
        require 'vagrant-vmware-workstation/action'
        require 'vagrant-vmware-workstation/driver'

        require_relative 'actions/provider/vmware-workstation/mount'
        require_relative 'actions/provider/vmware-workstation/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
        STDERR.puts "Vagrant plugin VMWare Workstation not available, ignoring code\n  Error: #{$!}"
      end

      # Parallels Desktop
      begin
        require 'vagrant-parallels/action'
        require 'vagrant-parallels/driver'

        require_relative 'actions/provider/parallels/mount'
        require_relative 'actions/provider/parallels/driver'
      rescue LoadError
        # If plugin cannot be loaded, silently ignore
        STDERR.puts "Vagrant plugin Parallels Desktop  not available, ignoring code\n  Error: #{$!}"
      end
    end
  end
end
