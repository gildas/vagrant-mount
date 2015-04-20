require 'pathname'

module HashiCorp
  module VagrantVMwarefusion
    module Driver
      class Base
        def mount(mount_point)
          @logger.info "Mounting #{mount_point}"
          info = vminfo(vmx_path)
          begin
            controller_name = find_iso(info, mount_point)
            @logger.debug "Already mounted on #{controller_name}"
            return 1
          rescue KeyError
            @logger.debug "Not mounted, we are good to go"
          end
          begin
            controller_name = find_free_port(info)
            @logger.info "Mounting on: #{controller_name}"
            info["#{controller_name}.devicetype"]     = "cdrom-image"
            info["#{controller_name}.filename"]       = Pathname.new(mount_point).realpath.to_s
            info["#{controller_name}.present"]        = "TRUE"
            info["#{controller_name}.autodetect"]     = "TRUE"
            info["#{controller_name}.startconnected"] = "TRUE"
            vmsave(vmx_path, info)
            return 1
          rescue KeyError
            @logger.error "Could not find any free port"
            return 0
          end
        end

        def unmount(mount_point, remove_device=false)
          @logger.info "Unmounting #{mount_point}"
          info = vminfo(vmx_path)
          begin
            controller_name = find_iso(info, mount_point)
            @logger.info "Mounted on #{controller_name}"
            info["#{controller_name}.devicetype"]     = "cdrom-raw"
            info["#{controller_name}.filename"]       = "auto detect"
            info["#{controller_name}.present"]        = "TRUE"
            info["#{controller_name}.autodetect"]     = "TRUE"
            info["#{controller_name}.startconnected"] = "FALSE"
            vmsave(vmx_path, info)
            return 1
          rescue KeyError
            @logger.debug "Not mounted, nothing to do"
            return 0
          end
        end

        def vminfo(path)
          return Hash[*File.readlines(path).map {|line| line.scan(/^(.+?) = "(.*?)"$/m)}.flatten]
        end

        def vmsave(path, vm_info)
          temp_path="#{path}.new"
          @logger.debug "Saving in: #{temp_path}"
          File.open("#{temp_path}", "w") { |f| vm_info.each{|k,v| f.puts "#{k} = \"#{v}\""}}
          FileUtils.mv temp_path, path, force: true
        end

        def find_iso(vm_info, mount_point)
          data = vm_info.find {|k, v| v =~ /.*\/#{mount_point}/ }
          raise KeyError unless data
          @logger.debug "Found data: #{data.inspect}"
          data[0] =~ /([a-z]+)(\d+):(\d+)\.filename/
          raise KeyError unless data[0] =~ /([a-z]+)(\d+):(\d+)\.filename/
          @logger.debug "type: #{$1}, device: #{$2}, port: #{$3}"
          "#{$1}#{$2}:#{$3}"
        end

        def find_free_port(vm_info)
          data = vm_info.find {|k, v| v == 'cdrom-raw' }
          raise KeyError unless data
          @logger.debug "Found data: #{data.inspect}"
          raise KeyError unless data[0] =~ /([a-z]+)(\d+):(\d+)\.devicetype/
          @logger.debug "type: #{$1}, device: #{$2}, port: #{$3}"
          "#{$1}#{$2}:#{$3}"
        end
      end
    end
  end
end
