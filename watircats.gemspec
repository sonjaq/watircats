# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watircats/version"

Gem::Specification.new do |s|
  s.name        = "cw_wraith"
  s.version     = WatirCats::VERSION
  s.authors     = ["Andrew Leaf"]
  s.email       = ["andrew@clockwork.net"]
  s.homepage    = "https://github.com/ClockworkNet/"
  s.summary     = %q{Page discovery, screenshotting and comparison tool}
  s.description = %q{Page discovery, screenshotting and comparison tool}
  s.license     = 'MIT'

  s.files         = `ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = 'watircats'
  s.require_paths = ["lib"]

  s.add_dependency 'thor', '>=0.17.0'
  s.add_dependency 'require_all'
  s.add_dependency 'watir-webdriver'
  s.add_dependency 'xml-simple'
  s.add_dependency 'open-uri'
end