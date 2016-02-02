require 'benchmark'
require 'fileutils'

def tmp_mv(old_name, new_name, verbose = false, &block)
  FileUtils.mv old_name, new_name, verbose: verbose
  block.call
  FileUtils.mv new_name, old_name, verbose: verbose
end

def clobber
  Dir.chdir "./app" do
    puts `bundle exec rake clobber`
  end
end

desc "test"
task :test do
  # remove precompile cache
  clobber

  Benchmark.bm do |x|
    x.report "precompile switching app dir 1" do
      tmp_mv './app', 'app1' do
        Dir.chdir "./app1" do
          `bundle exec rake precompile USE_DEPENDENCY=0`
        end
      end
    end
    
    x.report "precompile switching app dir 2" do
      tmp_mv './app', 'app2' do
        Dir.chdir "./app2" do
          `bundle exec rake precompile USE_DEPENDENCY=0`
        end
      end
    end

    # remove precompile cache
    clobber

    x.report "precompile switching app dir w/ dependency 1" do
      tmp_mv './app', 'app1' do
        Dir.chdir "./app1" do
          `bundle exec rake precompile`
        end
      end
    end
    
    x.report "precompile switching app dir w/ dependency 2" do
      tmp_mv './app', 'app2' do
        Dir.chdir "./app2" do
          `bundle exec rake precompile`
        end
      end
    end
  end
end

desc "test precompile"
task :test_precompile do
  Dir.chdir './app' do
    `bundle exec rake clobber precompile && ls -al app/public/static/`
  end
end
