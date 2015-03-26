module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      class Base
        def mount(mount_point)
          info = get_vm_info(@uuid)
          # Find an IDE or SCSI controller
          begin
            ide_types  = ['PIIX3', 'PIIX4', 'ICH6']
            controller, device, port = find_controller_and_port(info, ide_types)
            execute('storageattach', @uuid, "--storagectl \"#{controller}\" --device #{device} --port #{port} --type dvddrive --medium \"#{mount_point}\"")
          rescue 
            STDERR.puts "Nope... #{$!}"
          end
        end

        def find_controller_and_port(vm_info, controller_types)
          controller = info[:storagecontrollers].find {|storage| controller_types.include?(storage[:type]) }
          raise KeyError, 'No suitable Controller on this VM' unless controller
STDERR.puts "Found a suitable Storage: #{controller[:name]}"
          device = controller[:controllers].find_index { |dev| dev[:ports].find(nil) }
          raise IndexError, 'No controller with free ports' unless device
puts "  device id: #{device}"
          port = controller[:controllers][device][:ports].find_index(nil)
          raise "No free port for controller #{controller_id}" unless port_id
puts "  port id: #{port_id}"
          return [controller[:name], device, port]
        end

        def get_vm_info(name_or_uuid)
          output = execute('showvminfo', name_or_uuid, '--machinereadable')
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
                    device = controller[:devices][$3.to_i]
                    raise IndexError, $3.to_i unless device
                    raise IndexError, $4.to_i unless $4.to_i < 2
                    device[:ports][$4.to_i] ||= {}
                    device[:ports][$4.to_i][key] = value
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
