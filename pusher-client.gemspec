# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = 'pusher-client'
  s.version = "0.2.2"
  s.authors = ["Logan Koester", "Phil Leggetter"]
  s.description = %q{Ruby client for consuming WebSockets from http://pusher.com}
  s.email = %q{support@pusher.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "examples/hello_pusher.rb",
    "examples/hello_pusher_async.rb",
    "lib/pusher-client.rb",
    "lib/pusher-client/channel.rb",
    "lib/pusher-client/channels.rb",
    "lib/pusher-client/socket.rb",
    "lib/pusher-client/websocket.rb",
    "certs/cacert.pem",
    "pusher-client.gemspec",
    "test/pusherclient_test.rb",
    "test/test.watchr",
    "test/teststrap.rb"
  ]
  s.homepage = %q{http://github.com/pusher/pusher-ruby-client}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby client for consuming WebSockets from http://pusher.com}
  s.test_files = [
    "examples/hello_pusher.rb",
    "examples/hello_pusher_async.rb",
    "test/pusherclient_test.rb",
    "test/teststrap.rb"
  ]

  s.add_runtime_dependency(%q<websocket>, ["~> 1.0.0"])
  s.add_runtime_dependency(%q<ruby-hmac>, ["~> 0.4.0"])
  s.add_development_dependency(%q<bacon>, [">= 0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
end

