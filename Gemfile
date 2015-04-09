source 'http://rubygems.org'
#source 'http://gems.hashicorp.com'

def which(command, *additional_paths)
  extensions = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).push(*additional_paths).each do |path|
    extensions.each do |extension|
      filepath = File.join(path, "#{command}#{extension}")
      return filepath if File.executable?(filepath) && !File.directory?(filepath)
    end
  end
  return nil
end

def has_vmware_fusion?
  return ! which('vmrun', '/Applications/VMware Fusion.app/Contents/Library').nil?
end

vagrant_locations = %w{ /Applications/Vagrant/embedded /opt/vagrant/embedded C:/HashiCorp/Vagrant/embedded }
vagrant_location  = vagrant_locations.find {|location| File.directory? location }

if vagrant_location
  ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'] = vagrant_location
  puts "Using vagrant from #{vagrant_location}" if $DEBUG
else
  STDERR.puts 'Could not find an official install of vagrant! The RubyEncoder libraries will not work.'
end

puts "We can use VMWare Fusion" if has_vmware_fusion? && $DEBUG

group :development do
  gem 'vagrant', github: 'mitchellh/vagrant', tag: 'v1.7.2'
  gem 'rake'

  if has_vmware_fusion?
    require 'fileutils'

    fusion_location = Gem::Specification.find_by_name('vagrant-vmware-fusion').gem_dir
    puts "VMWare fusion gem is in #{fusion_location}"

    unless File.symlink?(File.join(fusion_location, 'rgloader'))
      STDERR.puts "Linking local 'rgloader' file to embedded installer"
      FileUtils.ln_s(
        File.join(ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'], 'rgloader'),
        File.join(fusion_location,                       'rgloader')
      )
    end

    unless File.symlink?(File.join(fusion_location, 'license-vagrant-vmware-fusion.lic'))
      STDERR.puts "Linking your license file for vmware plugin"
      vagrant_home = ENV["VAGRANT_HOME"] || File.join(ENV['HOME'], '.vagrant.d')
      FileUtils.ln_s(
        File.join(vagrant_home,    'license-vagrant-vmware-fusion.lic'),
        File.join(fusion_location, 'license-vagrant-vmware-fusion.lic')
      )
    end
  end
end

group :plugins do
  gem 'vagrant-vmware-fusion' if has_vmware_fusion?
  #gem 'vagrant-mount', path: '.'
  gemspec
end
