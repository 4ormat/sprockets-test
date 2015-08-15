require 'sprockets'

class Foo
  attr :assets
  attr :asset_paths
  attr :manifest
  attr :output

  def initialize
    @assets = Sprockets::Environment.new
    @assets.append_path 'assets/images'
    @assets.append_path 'assets/javascripts'
    @assets.append_path 'assets/stylesheets'

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

  def clean
    @manifest.compile(asset_paths)
  end

  def clobber
    @manifest.clobber
  end

  def call(env)
    ['200', {'Content-Type' => 'text/html'}, ['rooooooot']]
  end
end
