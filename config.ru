require 'rubygems'
require 'bundler/setup'
require 'rack'
require './foo'

foo = Foo.new

app = Rack::Builder.new do
  map '/assets' do
    run foo.assets
  end

  map '/' do
    run foo
  end
end

run app