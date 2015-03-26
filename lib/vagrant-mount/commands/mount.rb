require 'optparse'
require 'vagrant'

module VagrantPlugins
  module Mount
    module Command
      class Mount < Vagrant.plugin('2', :command)
        def self.synopsis
          'Mount ISO in Virtual Machine'
        end

        def initialize(argv, env)
          super
        end

        def execute
          options = {}
          parser  = OptionParser.new do |opts|
            opts.banner = 'Usage: vagrant mount [options] [vm-name]'
            opts.separator ''
            opts.separator '  where path points to an ISO'
            opts.separator ''
            opts.separator '  Options:'
            opts.on("--iso path", "The path of the ISO to mount") { |arg| options[:mount] = arg }
          end

          argv = parse_options(parser)
          return unless argv
          if argv.empty? || argv.length > 2
            raise Vagrant::Errors::CLIInvalidUsage, help: parser.help.chomp
          end

          raise Vagrant::Errors::CLIInvalidUsage, { help: parser.help.chomp } unless options[:mount]
          with_target_vms(argv) do |vm|
            next if vm.state.id == :not_created # We cannot mount if not created
            vm.action(:mount, mount_point: options[:mount])
          end
          0
        end
      end
    end
  end
end