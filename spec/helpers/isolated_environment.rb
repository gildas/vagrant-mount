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

  def file(name, contents, root=nil)
    (root || @workdir).join(name).open('w+') { |f| f.write(contents) }
  end

  def vagrantfile(contents, root=nil)
    file('Vagrantfile', contents, root)
  end

  def box(name, vagrantfile_contents='')
    box_dir=boxes_dir.join(name)
    box_dir.mkpath

    box_dir.join('box.ovf').open('w') { |f| f.write('') }
    vagrantfile(vagrantfile_contents, box_dir)
    box_dir
  end

  def boxes_dir
    dir=@homedir.join('boxes')
    dir.mkpath
    dir
  end
end
