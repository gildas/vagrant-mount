require 'optparse'
require 'vagrant'

module VagrantPlugins
  module Mount
    module Command
      class Unmount < Vagrant.plugin('2', :command)
        def self.synopsis
          'Unmount ISO from Virtual Machine'
        end

        def initialize(argv, env)
          @env=env
          super
        end

        def execute
          options = { keep: false }
          parser  = OptionParser.new do |opts|
            opts.banner = 'Usage: vagrant unmount [options] [vm-name]'
            opts.separator ''
            opts.separator '  Options:'
            opts.on("--iso path", "The path of the ISO to unmount") { |arg| options[:path] = arg }
            opts.on("--keep", "Keep the controller/device/port after unmounting") { |arg| options[:keep] = true }
          end

          argv = parse_options(parser)
          return unless argv
          argv << "default" if argv.empty?

          raise Vagrant::Errors::CLIInvalidUsage, { help: parser.help.chomp } unless options[:path]
          with_target_vms(argv) do |vm|
            vm.action(:unmount, mount_point: options[:path], keep: options[:keep])
          end
          0
        end
      end
    end
  end
end
