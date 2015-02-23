require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'logger'

class IsolatedEnvironment
  attr_reader :homedir
  attr_reader :workdir

  def initialize
    Dir.mkdir 'tmp' unless Dir.exists? 'tmp'
    @logger = Logger.new(File.open('tmp/isolated_environment.log', 'a'))
    @tempdir = Dir.mktmpdir('vagrant')
    @logger.info("Initialized Isolated Environment in #{@tempdir}")
    @homedir = Pathname.new(File.join(@tempdir, 'home'))
    @workdir = Pathname.new(File.join(@tempdir, 'work'))
    @homedir.mkdir
    @workdir.mkdir
  end

  def create_environment(options=nil)
    Vagrant::Environment.new({cwd: workdir, home_path: homedir}.merge(options || {}))
  end

  def close
    @logger.info("Removing Isolated Environment from #{@tempdir}")
    FileUtils.rm_rf(@tempdir)
  end
end
