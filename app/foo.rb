require 'sprockets'
require 'tmpdir'
require 'fileutils'
require 'byebug'

class Foo
  attr :assets
  attr :asset_paths
  attr :manifest
  attr :output

  def initialize
    @use_dependency = ENV['USE_DEPENDENCY'] != '0'
    @use_symlink = ENV['USE_SYMLINK'] != '0'
    @dependency_symlink = File.expand_path("../dependency_link", __FILE__)

    @assets = Sprockets::Environment.new
    @assets.append_path 'assets/images'
    @assets.append_path 'assets/javascripts'
    @assets.append_path 'assets/stylesheets'
    @assets.append_path 'assets/stylesheets'

    @output = 'public/static'

    @manifest = Sprockets::Manifest.new(@assets, @output)

    @assets.cache = Sprockets::Cache::FileStore.new('tmp/cache')

    

    @logger = Logger.new($stderr)
    @assets.logger = @logger
    if ENV['DEBUG']
      @logger.level = Logger::INFO
    else
      @logger.level = Logger::FATAL
    end
  end

  def asset_paths
    @asset_paths ||= @assets.paths.map{|path| @assets.entries(path)}.flatten
  end

  def precompile(use_dependency = @use_dependency, use_symlink = @use_symlink)
    if use_dependency
      create_dependency_in_random_dir do |dir|
        if use_symlink
          File.symlink dir, @dependency_symlink
          require File.expand_path(@dependency_symlink + '/dependency.rb')
        else
          require File.expand_path(dir + '/dependency.rb')
        end
        @assets.append_path Dependency::ASSET_DIR
        @manifest.compile(asset_paths)

        FileUtils.rm_r(@dependency_symlink) if use_symlink
      end
    else
      @manifest.compile(asset_paths)
    end
  end

  def clobber
    @manifest.clobber
  end

  def create_dependency_in_random_dir
    Dir.mktmpdir do |dir|
      FileUtils.cp_r File.expand_path("../dependency", __FILE__), dir
      dep_dir = File.expand_path(dir + '/dependency')
      yield dep_dir
    end
  end

  def call(env)
    ['200', {'Content-Type' => 'text/html'}, ['rooooooot']]
  end
end
