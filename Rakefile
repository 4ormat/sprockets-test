require 'dir'
require 'benchmark'

desc "test"
task :test do
  # setup asset symlink
  `ln -fnsv ./source ./app1`
  Benchmark.bm do |x|
    x.report "precompile #1" do
      Dir.chdir "./app1" do
        `bundle exec rake precompile`
      end
    end
    
    # switch asset symlink 
    `ln -fnsv ./sources ./app2`
    Dir.chdir "./app2" do
      x.report "precompile #2" do
        `bundle exec rake precompile`
      end
    end
  end
end