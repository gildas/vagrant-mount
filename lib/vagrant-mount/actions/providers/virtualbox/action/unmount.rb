
module VagrantPlugins
  module ProviderVirtualBox
    module Action
      class Unmount
        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_mount.actions.vm.mount.unmounting', mount: env[:mount_point]))
          env[:result] = env[:machine].provider.driver.unmount(env[:mount_point], env[:keep])
          @app.call(env)
        end
      end
    end
  end
end
