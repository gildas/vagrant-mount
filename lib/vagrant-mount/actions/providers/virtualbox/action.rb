require 'vagrant'
require 'vagrant/action/builder'

module VagrantPlugins
  module ProviderVirtualBox
    module Action
        autoload :Mount,             File.expand_path("../action/mount.rb", __FILE__)
        autoload :MessageNotMounted, File.expand_path("../action/message_not_mounted.rb", __FILE__)

        def self.action_mount
          Vagrant::Action::Builder.new.tap do |builder|
            builder.use CheckVirtualbox
            builder.use Call, Created do |created_env, created_builder|
              if created_env[:result]
                created_builder.use CheckAccessible
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

    end
  end
end
