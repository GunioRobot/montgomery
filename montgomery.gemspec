# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "montgomery/version"

Gem::Specification.new do |s|
  s.name        = "montgomery"
  s.version     = Montgomery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wojciech Piekutowski"]
  s.email       = ["wojciech@piekutowski.net"]
  s.homepage    = "https://github.com/wpiekutowski/montgomery"
  s.summary     = %q{A thin and lean Ruby object mapping layer for MongoDB}
  s.description = %q{Montogomery is a very simplistic and thin layer over the existing Ruby MongoDB driver. It turns MongoDB into a kind of persistent object storage. Still the programmer has to decide when an object should be saved and what goes to the database. Montgomery tries to stay away from your plain Ruby classes as much as possible, contrary to some other ORMs out there. Because of that the source code is easy to follow and understand, so skilled Rubyist can adjust it to every project's needs.}

  s.rubyforge_project = "montgomery"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  mongo_version = "=1.2.2"
  s.add_dependency "mongo", mongo_version
  s.add_dependency "bson", mongo_version

  s.add_development_dependency "bson_ext", mongo_version
  s.add_development_dependency "rspec", "~>2.0"
  s.add_development_dependency "ZenTest", "~>4.0"
  s.add_development_dependency "autotest-notification"
  s.add_development_dependency "faker"
  s.add_development_dependency "wirble"
  s.add_development_dependency "rvm"
end
