module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      class Base
        def mount(mount_point)
          # Find an IDE or SCSI controller
          @logger.debug "Mounting #{mount_point}"
          info = get_vm_info(@uuid)
          begin
            controller_name, device_id, port_id = find_iso(info, mount_point)
            @logger.debug "Already mounted on #{controller_name}, device: #{device_id}, port: #{port_id}"
            return 1
          rescue KeyError
            @logger.debug "Not mounted yet, we are good to go"
          end
          ide_types  = ['PIIX3', 'PIIX4', 'ICH6']
          controller_name, device_id, port_id = find_free_port(info, ide_types)
          execute('storageattach', @uuid,
                  '--storagectl', controller_name,
                  '--device', device_id.to_s,
                  '--port', port_id.to_s,
                  '--type', 'dvddrive',
                  '--medium', mount_point
                 )
        end

        def unmount(mount_point, keep=false)
          # Find an IDE or SCSI controller
          @logger.debug "Mounting #{mount_point}"
          info = get_vm_info(@uuid)
          begin
            controller_name, device_id, port_id = find_iso(info, mount_point)
            @logger.debug "Mounted on #{controller_name}, device: #{device_id}, port: #{port_id}"
            if keep
              execute('storageattach', @uuid,
                      '--storagectl', controller_name,
                      '--device', device_id.to_s,
                      '--port', port_id.to_s,
                      '--type', 'dvddrive',
                      '--medium', 'emptydrive'
                    )
            else
              execute('storageattach', @uuid,
                      '--storagectl', controller_name,
                      '--device', device_id.to_s,
                      '--port', port_id.to_s,
                      '--medium', 'none'
                    )
            end
          rescue KeyError
            @logger.debug "Not mounted, we cannot proceed"
            return 0
          end
        end

        def find_iso(vm_info, mount_point)
          device_id = port_id = nil
          controller = vm_info[:storagecontrollers].find do |ctrl|
            device_id = ctrl[:devices].find_index do |device|
              port_id = device[:ports].find_index do |port|
                port[:mount].include? mount_point if port
              end
            end
          end
          raise KeyError unless controller
          @logger.debug "Found ISO on Storage: #{controller[:name]}, device ##{device_id}, port ##{port_id}"
          return [controller[:name], device_id, port_id]
        end

        def find_free_port(vm_info, controller_types)
          device_id = port_id = nil
          controller = vm_info[:storagecontrollers].find do |ctrl|
            device_id = ctrl[:devices].find_index do |device|
              port_id = device[:ports].find_index do |port|
                port.nil? || port[:mount] == 'emptydrive'
              end
            end
          end
          raise KeyError, "No suitable Controller on VM #{@uuid}" unless controller
          @logger.debug "Found a suitable Storage: #{controller[:name]}, device ##{device_id}, port ##{port_id}"
          return [controller[:name], device_id, port_id]
        end

        def get_vm_info(name_or_uuid)
          @logger.debug "Fetching info for VM #{name_or_uuid}"
          output = execute('showvminfo', name_or_uuid, '--machinereadable', retryable: true)
          nic_index = nil
          output.split("\n").inject({storagecontrollers: [], nics: [], lpts: [], uarts: []}) do |hash, line|
            if line =~ /^"?([^="]+)"?="?(|[^"]+)"?$/
              key   = $1
              value = $2.to_s
              case key
                when /^storagecontroller([a-z]+)(\d+)$/
                  key   = $1.tr('- ', '__').to_sym
                  controller = hash[:storagecontrollers][$2.to_i]
                  if controller
                    controller[key] = value
                    if key == :portcount
                      controller[:devices] = value.to_i.times.inject([]) {|array| array << { ports: [nil, nil] } }
                    end
                  else
                    hash[:storagecontrollers] << { key => value }
                  end
                when /^([a-zA-Z ]+)(?:-([a-zA-Z]+))?-(\d+)-(\d+)$/
                  unless value == 'none'
                    key        = ($2 || 'mount').tr('- ', '__').to_sym
                    controller = hash[:storagecontrollers].find { |s| s[:name] == $1 }
                    raise KeyError, $1 unless controller
                    device = controller[:devices][$4.to_i]
                    raise IndexError, $4.to_i unless device
                    raise IndexError, $3.to_i unless $3.to_i < 2
                    device[:ports][$3.to_i] ||= {}
                    device[:ports][$3.to_i][key] = value
                  end
                when /^natnet(\d+)$/
                  nic_index = $1.to_i - 1
                  hash[:nics][nic_index] ||= { forwardings: [] }
                  hash[:nics][nic_index][:natnet] = value
                when /^(cableconnected|macaddress|nic|nictype|nicspeed)(\d+)$/
                  hash[:nics][$2.to_i - 1][$1.to_sym] = value unless value == 'none'
                when /^(mtu|sockSnd|sockRcv|tcpWndSnd|tcpWndRcv)$/
                  hash[:nics][nic_index][$1.to_sym] = value
                when /^Forwarding\((\d+)\)$/
                  hash[:nics][nic_index][:forwardings][$1.to_i] = value
                when /^(lpt|uart)(\d+)$/
                  hash[($1 << 's').to_sym][$2.to_i - 1] = value
                else
                  hash[key.tr('- ','__').to_sym] = value
              end
            end
            hash
          end
        end
      end
    end
  end
end
