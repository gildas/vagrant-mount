source 'http://rubygems.org'

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

def has_parallels?
  return ! which('prlctl').nil?
end

vagrant_locations = %w{ /Applications/Vagrant/embedded /opt/vagrant/embedded C:/HashiCorp/Vagrant/embedded }
vagrant_location  = vagrant_locations.find {|location| File.directory? location }

if vagrant_location
  ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'] = vagrant_location
  puts "Using vagrant from #{vagrant_location}" if $DEBUG
else
  STDERR.puts 'Could not find an official install of vagrant! The RubyEncoder libraries will not work.'
  exit 1
end

puts "We can use VMWare Fusion" if has_vmware_fusion? && $DEBUG
puts "We can use Parallels"     if has_parallels? && $DEBUG

group :plugins do
  gem 'rgloader'                                                   if has_vmware_fusion?
  gem 'vagrant-vmware-fusion', source: 'http://gems.hashicorp.com' if has_vmware_fusion?
  gem 'vagrant-parallels'                                          if has_parallels?
  gemspec
end

group :development do
  gem 'winrm', '~> 1.1.3'
  gem 'vagrant', github: 'mitchellh/vagrant', tag: 'v1.7.2'
  gem 'rake'

  if has_vmware_fusion?
    require 'fileutils'

    begin
      STDERR.puts "Finding where gem vagrant-vmware-fusion is installed" if $DEBUG
      fusion_location = Gem::Specification.find_by_name('vagrant-vmware-fusion').gem_dir
      puts "VMWare fusion gem is in #{fusion_location}" if $DEBUG

      unless Dir.exists? File.join(fusion_location, 'rgloader')
        STDERR.puts "Linking local 'rgloader' file to embedded installer" if $DEBUG
        FileUtils.ln_s(
          File.join(ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'], 'rgloader'),
          File.join(fusion_location,                       'rgloader')
        )
      end

      unless File.symlink?(File.join(fusion_location, 'license-vagrant-vmware-fusion.lic'))
        STDERR.puts "Linking your license file for vmware plugin" if $DEBUG
        vagrant_home = ENV["VAGRANT_HOME"] || File.join(ENV['HOME'], '.vagrant.d')
        FileUtils.ln_s(
          File.join(vagrant_home,    'license-vagrant-vmware-fusion.lic'),
          File.join(fusion_location, 'license-vagrant-vmware-fusion.lic')
        )
      end
    rescue Gem::LoadError
      STDERR.puts "Cannot load Vagrant VMWare plugin. #{$!}"
    end
  end
end
