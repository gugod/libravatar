require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "libravatar"
  gem.homepage = "http://github.com/gugod/libravatar"
  gem.license = "MIT"
  gem.summary = %Q{Avatar URL Generation wih libravatar.org}
  gem.description = %Q{libravatar.org provides avatar image hosting (like gravatar.com). Their users may associate avatar images with email or openid. This rubygem can be used to generate libravatar avatar image URL}
  gem.email = "gugod@gugod.org"
  gem.authors = ["Kang-min Liu"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  # gem.add_runtime_dependency 'digest/sha2', '> 0.1'
  # gem.add_runtime_dependency 'uri', '> 0.1'
  gem.add_development_dependency 'shoulda', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "libravatar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
