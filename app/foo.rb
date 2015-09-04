require 'sprockets'
require 'tmpdir'
require 'fileutils'

class Foo
  attr :assets
  attr :asset_paths
  attr :manifest
  attr :output

  def initialize
    @dependency_dir = create_dependency_in_random_dir
    require File.expand_path(@dependency_dir + '/dependency.rb')

    @assets = Sprockets::Environment.new
    @assets.append_path 'assets/images'
    @assets.append_path 'assets/javascripts'
    @assets.append_path 'assets/stylesheets'
    @assets.append_path 'assets/stylesheets'
    @assets.append_path Dependency::ASSET_DIR

    @output = 'public/static'

    @manifest = Sprockets::Manifest.new(@assets, @output)

    @assets.cache = Sprockets::Cache::FileStore.new('tmp/cache')

    @logger = Logger.new($stderr)
    @logger.level = Logger::INFO
    @assets.logger = @logger
  end

  def asset_paths
    @asset_paths ||= @assets.paths.map{|path| @assets.entries(path)}.flatten
  end

  def precompile
    @manifest.compile(asset_paths)
  end

  def clobber
    @manifest.clobber
  end

  def create_dependency_in_random_dir
    dir = Dir.mktmpdir
    FileUtils.cp_r File.expand_path("../dependency", __FILE__), dir
    ObjectSpace.define_finalizer self, -> {
      FileUtils.rm_r(dir)
    }
    File.expand_path(dir + '/dependency')
  end

  def call(env)
    ['200', {'Content-Type' => 'text/html'}, ['rooooooot']]
  end
end
