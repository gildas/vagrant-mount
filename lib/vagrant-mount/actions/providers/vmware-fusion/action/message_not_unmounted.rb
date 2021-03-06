module HashiCorp
  module VagrantVMwarefusion
    module Action
      class MessageNotUnmounted
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_mount.errors.vm.unmount.not_unmounted', mount: env[:mount_point]))
          @app.call(env)
        end
      end
    end
  end
end
