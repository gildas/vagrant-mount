module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      class Meta
        def_delegators @driver, :mount
      end
    end
  end
end
