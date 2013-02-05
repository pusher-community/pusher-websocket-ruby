# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pusher-client}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Logan Koester", "Phil Leggetter"]
  s.date = %q{2011-01-07}
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
    "VERSION",
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

  s.add_runtime_dependency(%q<libwebsocket>, ["0.1.5"])
  s.add_runtime_dependency(%q<ruby-hmac>, ["~> 0.4.0"])
  s.add_runtime_dependency(%q<addressable>, ["~> 2.3.1"])
  s.add_development_dependency(%q<bacon>, [">= 0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<ruby-debug19>, [">= 0"])

end

