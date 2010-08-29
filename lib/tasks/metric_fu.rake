begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    config.rcov[:rcov_opts] << "-Itest" 
  end

  namespace :build do

    desc "Fix temporary directory location"
    task :fixtmp do |t|
      system "mkdir -p ../tmp"
      system "chmod 777 ../tmp"
      system "rm -rf ./tmp"
      system "ln -s ../tmp ."
    end

    desc "Run metrics"
    task :metrics => :fixtmp do |t|
      Rake::Task['metrics:all'].invoke
    end

  end

rescue LoadError
end

