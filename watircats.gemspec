# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watircats/version"

Gem::Specification.new do |s|
  s.name        = "watircats"
  s.version     = WatirCats::VERSION
  s.authors     = ["Andie Leaf"]
  s.email       = ["avleaf@gmail.com"]
  s.homepage    = "https://github.com/ClockworkNet/watircats"
  s.summary     = %q{Page discovery, screenshotting and comparison tool}
  s.description = %q{Responive screenshot and comparison tool using Watir-WebDriver.}
  s.license     = 'MIT'

  s.rubyforge_project = 'watircats'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'require_all', '~> 1.3'
  s.add_dependency 'thor', '~> 0.18'
  s.add_dependency 'watir-webdriver', '~> 0.8'
  s.add_dependency 'xml-simple', '~> 1.1'
  s.add_dependency 'haml', '~> 4.0'
  s.add_dependency 'psych', '~> 2.0'
  s.add_dependency 'minitest', '~> 5.0'
  s.add_dependency 'autotest', '~> 4.4'
end
