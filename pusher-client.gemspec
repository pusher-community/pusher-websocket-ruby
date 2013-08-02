# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name             = 'pusher-client'
  s.version          = "0.3.0"
  s.authors          = ["Logan Koester", "Phil Leggetter"]
  s.email            = ['support@pusher.com']
  s.homepage         = 'http://github.com/pusher/pusher-ruby-client'
  s.summary          = 'Client for consuming WebSockets from http://pusher.com'
  s.description      = 'Client for consuming WebSockets from http://pusher.com'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f|
    File.basename(f)
  }
  s.extra_rdoc_files = %w(LICENSE.txt README.rdoc)
  s.require_paths    = ['lib']
  s.licenses         = ['MIT']

  s.add_runtime_dependency 'websocket', '~> 1.0.0'
  s.add_runtime_dependency 'ruby-hmac', '~> 0.4.0'
  s.add_runtime_dependency 'json' if RUBY_VERSION < "1.9"

  s.add_development_dependency 'bacon', '>= 0'
  s.add_development_dependency 'rake',  '>= 0'
end
