# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paceman/version"

Gem::Specification.new do |s|
  s.name        = "paceman"
  s.version     = Paceman::VERSION
  s.authors     = ["Stephen von Takach"]
  s.email       = ["steve@cotag.me"]
  s.homepage    = "https://github.com/cotag/paceman"
  s.summary     = "A concurrent web server for ruby"
  s.description = <<-EOF
    Faster than a speeding Puma. At least that is the aim.
    With cross platform and cross ruby implementation support thanks to ffi.
  EOF


  s.add_dependency 'ffi-compiler', '>= 0.0.2'
  s.add_dependency 'rake'
  s.add_dependency 'uvrb'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  

  s.files = Dir["{lib}/**/*"] + %w(Rakefile paceman.gemspec README.md LICENSE)
  s.files += ["ext/http-parser/http_parser.c", "ext/http-parser/http_parser.h"]
  s.test_files = Dir["spec/**/*"]
  s.extra_rdoc_files = ["README.md"]

  s.extensions << "ext/Rakefile"
  s.require_paths = ["lib"]
end
