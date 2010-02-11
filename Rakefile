require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

spec = Gem::Specification.new do |s|
  s.name              = "rack-nocache"
  s.version           = "0.1.0"
  s.summary           = "Rack::Nocache ensures all requests are uncached"
  s.author            = "Tom Lea"
  s.email             = "contrib@tomlea.co.uk"
  s.homepage          = "http://tomlea.co.uk"

  s.files             = Dir.glob("lib/**/*")
  s.require_paths     = ["lib"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Clear out RDoc and generated packages'
task :clean => :clobber_package
