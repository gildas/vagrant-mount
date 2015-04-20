module HashiCorp
  module VagrantVMwarefusion
    module Action
      class MessageNotMounted
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_mount.errors.vm.mount.not_mounted', mount: env[:mount_point]))
          @app.call(env)
        end
      end
    end
  end
end
