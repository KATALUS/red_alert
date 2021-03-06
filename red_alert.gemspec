# -*- encoding: utf-8 -*-
require File.expand_path('../lib/red_alert/version', __FILE__)

Gem::Specification.new do |gem|
  gem.author        = 'vyrak.bunleang@gmail.com'
  gem.description   = 'Middlewares for mailing errors'
  gem.summary       = 'Middlewares for mailing errors'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "red_alert"
  gem.require_paths = ["lib"]
  gem.version       = RedAlert::VERSION

  gem.add_dependency 'mail', '>= 2.5.4'
  gem.add_development_dependency 'minitest', '= 5.2.1'
  gem.add_development_dependency 'rake'
end
