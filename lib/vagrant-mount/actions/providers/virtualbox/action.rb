require 'vagrant'
require 'vagrant/action/builder'

module VagrantPlugins
  module ProviderVirtualBox
    module Action
        autoload :Mount,             File.expand_path("../action/mount.rb", __FILE__)
        autoload :MessageNotMounted, File.expand_path("../action/message_not_mounted.rb", __FILE__)

        def self.action_mount
          Mount.logger.info "starting VagrantPlugins::ProviderVirtualBox::Action.action_mount"
          Vagrant::Action::Builder.new.tap do |builder|
            Mount.logger.info "  Builder: #{builder.inspect}"
            builder.use CheckVirtualbox
            builder.use Call, Created do |created_env, created_builder|
              Mount.logger.info "    Created: #{builder.inspect}"
              if created_env[:result]
                Mount.logger.info "    created_env[:result] contains: #{builder.inspect}"
                created_builder.use CheckAccessible
                Mount.logger.info "    CheckAccessible was a success"
                Mount.logger.info "    created_builder is calling Mount"
                created_builder.use Mount
                Mount.logger.info "    created_builder was called"
                #created_builder.use Call, Mount do |mount_env, mount_builder|
                #  unless mount_env[:result]
                #    mount_builder.use MessageNotMounted
                #  end
                #end
              else
                Mount.logger.error "    created_env[:result] error"
                created_builder.use MessageNotCreated
              end
            end
          end
        end

    end
  end
end
