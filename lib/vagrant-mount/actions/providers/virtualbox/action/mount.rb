module VagrantPlugins
  module ProviderVirtualBox
    module Action
      class Mount
        def initialize(app, env)
          Mount.logger "Initializing new Action::Mount for app #{app} (#{env.inspect})"
          @app = app
        end

        def call(env)
          Mount.logger "call Action::Mount for (#{env.inspect})"
          env[:ui].info(I18n.t('vagrant_mount.actions.vm.mount.mounting', mount: env[:mount_point]))
          env[:result] = env[:machine].provider.driver.mount(env[:mount_point])
          @app.call(env)
        end
      end
    end
  end
end
