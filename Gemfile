source 'https://rubygems.org'
source 'http://gems.hashicorp.com'

vagrant_locations = %w{ /Applications/Vagrant/embedded /opt/vagrant/embedded C:/HashiCorp/Vagrant/embedded }
vagrant_location  = vagrant_locations.find {|location| File.directory? location }

if vagrant_location
  ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'] = vagrant_location
else
  STDERR.puts 'Could not find an official install of vagrant! The RubyEncoder libraries will not work.'
end

group :development do
  gem 'vagrant', git: 'https://github.com/mitchellh/vagrant.git'
  gem 'rake'

  if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'vmware_fusion'
    require 'fileutils'

    fusion_location = Gem::Specification.find_by_name('vagrant-vmware-fusion').gem_dir

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
  gemspec

  gem 'vagrant-vmware-fusion' if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'vmware_fusion'
end
