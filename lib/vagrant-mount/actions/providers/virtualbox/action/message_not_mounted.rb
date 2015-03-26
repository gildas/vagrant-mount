module VagrantPlugins
  module ProviderVirtualBox
    module Action
      class MessageNotMounted
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_mount.actions.vm.mount.not_mounted', mount: env[:mount_point]))
          @app.call(env)
        end
      end
    end
  end
end
