module HashiCorp
  module VagrantVMwarefusion
    module Action
      class Mount
        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_mount.actions.vm.mount.mounting', mount: env[:mount_point]))
          env[:result] = env[:machine].provider.driver.mount(env[:mount_point])
          env[:ui].info(I18n.t('vagrant_mount.actions.vm.mount.mounted', mount: env[:mount_point]))
          @app.call(env)
        end
      end
    end
  end
end
