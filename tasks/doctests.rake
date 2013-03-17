namespace :test do
  desc "Run doctests"
  task :doctest do
    system("ruby #{File.dirname(__FILE__)}/../bin/rubydoctest #{File.dirname(__FILE__)}/../lib/*.rb") &&
      system("ruby #{File.dirname(__FILE__)}/../bin/rubydoctest #{File.dirname(__FILE__)}/../doc/*.doctest")
    exit($?.exitstatus)
  end

  namespace :doctest do
    desc "Run rstakeout on test/doctest files"
    task :auto do
      tests = "#{File.dirname(__FILE__)}/../test/doctest/*"
      tests_path = File.dirname(tests)
      files = "#{File.dirname(__FILE__)}/../lib/*.rb #{File.dirname(__FILE__)}/../bin/*"
      sh "#{File.dirname(__FILE__)}/../script/rstakeout 'rake test:doctest:changed DOCTESTS=#{tests_path}' #{tests} #{files} --pass-as-env"
    end

    desc "Run doctest(s) based on a specific file that changed"
    task :changed do
      file = ENV['CHANGED']
      doctests = ENV['DOCTESTS']
      unless file && doctests
        puts "Requires ENV['CHANGED']=file_path and ENV['DOCTESTS']=some/path/**/*.doctest"
        exit
      end
      tests = File.basename(file) =~ %r{\..*doctest\Z} ? file : doctests
      sh "ruby #{File.dirname(__FILE__)}/../bin/rubydoctest #{tests}"
    end
  end
end
