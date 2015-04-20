require 'vagrant'
require 'vagrant/action/builder'

module HashiCorp
  module VagrantVMwarefusion
    module Action
      autoload :Mount,             File.expand_path("../action/mount.rb", __FILE__)
      autoload :Unmount,           File.expand_path("../action/unmount.rb", __FILE__)
      autoload :MessageNotMounted, File.expand_path("../action/message_not_mounted.rb", __FILE__)
      autoload :MessageNotUnmounted, File.expand_path("../action/message_not_unmounted.rb", __FILE__)

      def self.action_mount
        Vagrant::Action::Builder.new.tap do |builder|
          builder.use CheckVMware
          builder.use Call, Created do |created_env, created_builder|
            if created_env[:result]
              created_builder.use Call, Mount do |mount_env, mount_builder|
                unless mount_env[:result]
                  mount_builder.use MessageNotMounted
                end
              end
            else
              created_builder.use MessageNotCreated
            end
          end
        end
      end

      def self.action_unmount
        Vagrant::Action::Builder.new.tap do |builder|
          builder.use CheckVMware
          builder.use Call, Created do |created_env, created_builder|
            if created_env[:result]
              created_builder.use Call, Unmount do |unmount_env, unmount_builder|
                unless unmount_env[:result]
                  unmount_builder.use MessageNotUnmounted
                end
              end
            else
              created_builder.use MessageNotCreated
            end
          end
        end
      end
    end
  end
end
