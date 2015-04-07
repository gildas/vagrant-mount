
module VagrantPlugins
  module ProviderVirtualBox
    module Action
      class Unmount
        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          if env[:mount_point]
            env[:ui].info(I18n.t('vagrant_mount.actions.vm.unmount.unmounting', mount: env[:mount_point]))
          else
            env[:ui].info(I18n.t('vagrant_mount.actions.vm.unmount.unmounting_all'))
          end
          env[:result] = env[:machine].provider.driver.unmount(env[:mount_point], env[:remove_device])
          if env[:mount_point]
            env[:ui].info(I18n.t('vagrant_mount.actions.vm.unmount.unmounted', mount: env[:mount_point]))
          else
            env[:ui].info(I18n.t('vagrant_mount.actions.vm.unmount.unmounted_all'))
          end
          @app.call(env)
        end
      end
    end
  end
end
