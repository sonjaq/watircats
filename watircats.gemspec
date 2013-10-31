# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watircats/version"

Gem::Specification.new do |s|
  s.name        = "WatirCats"
  s.version     = WatirCats::VERSION
  s.authors     = ["Andrew Leaf"]
  s.email       = ["andrew@clockwork.net"]
  s.homepage    = "https://github.com/ClockworkNet/WatirCats"
  s.summary     = %q{Page discovery, screenshotting and comparison tool}
  s.description = %q{Page discovery, screenshotting and comparison tool}
  s.license     = 'MIT'

  s.rubyforge_project = 'watircats'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'require_all'
  s.add_dependency 'thor', '>=0.17.0'
  s.add_dependency 'watir-webdriver'
  s.add_dependency 'xml-simple'
end