# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pbruby}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rub\303\251n Medell\303\255n"]
  s.date = %q{2009-08-26}
  s.description = %q{Peanut buttered Ruby! Access the PBWorks API (still in beta) from Ruby}
  s.email = %q{ruben.medellin.c@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "LICENSE",
     "README.md",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "lib/pbruby.rb",
     "lib/pbruby/client.rb",
     "lib/pbruby/pb_methods.rb",
     "pbruby.gemspec",
     "setup.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/chubas/pbruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Ruby wrapper for PBWorks (formerly PBWiki) API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
