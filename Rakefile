require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name          = "pbruby"
    gem.summary       = "Ruby wrapper for PBWorks (formerly PBWiki) API"
    gem.description   = "Peanut buttered Ruby! Access the PBWorks API (still in beta) from Ruby"
    gem.email         = "ruben.medellin.c@gmail.com"
    gem.homepage      = "http://github.com/chubas/pbruby"
    gem.authors       = ["Rubén Medellín"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :default => :test
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  elsif File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "peeping #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end