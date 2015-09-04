require 'benchmark'
require 'fileutils'

def tmp_mv(old_name, new_name, verbose = false, &block)
  FileUtils.mv old_name, new_name, verbose: verbose
  block.call
  FileUtils.mv new_name, old_name, verbose: verbose
end

desc "test"
task :test do
  # clobber any cache
  Dir.chdir "./app" do
    puts `bundle exec rake clobber`
  end

  Benchmark.bm do |x|
    x.report "precompile app1" do
      tmp_mv './app', 'app1' do
        Dir.chdir "./app1" do
          `bundle exec rake precompile`
        end
      end
    end
    
    x.report "precompile #2" do
      tmp_mv './app', 'app2' do
        Dir.chdir "./app2" do
          `bundle exec rake precompile`
        end
      end
    end
  end
end