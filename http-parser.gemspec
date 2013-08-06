# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "http-parser/version"

Gem::Specification.new do |s|
  s.name        = "http-parser"
  s.version     = HttpParser::VERSION
  s.authors     = ["Stephen von Takach"]
  s.email       = ["steve@cotag.me"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/cotag/http-parser"
  s.summary     = "Ruby bindings to joyent/http-parser"
  s.description = <<-EOF
    A super fast http parser for ruby.
    Cross platform and multiple ruby implementation support thanks to ffi.
  EOF


  s.add_dependency 'ffi-compiler', '>= 0.0.2'
  s.add_dependency 'rake'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  

  s.files = Dir["{lib}/**/*"] + %w(Rakefile http-parser.gemspec README.md LICENSE)
  s.files += ["ext/http-parser/http_parser.c", "ext/http-parser/http_parser.h"]
  s.test_files = Dir["spec/**/*"]
  s.extra_rdoc_files = ["README.md"]

  s.extensions << "ext/Rakefile"
  s.require_paths = ["lib"]
end
