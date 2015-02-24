module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      class Base
        def mount(mount_point)
          execute('showvminfo', @uuid, '--machinereadable')
        end
    end
  end
end
