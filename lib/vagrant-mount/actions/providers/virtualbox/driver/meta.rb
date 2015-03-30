module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      class Meta
        def_delegators :@driver, :mount, :unmount
      end
    end
  end
end
