# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/keys/version"

Gem::Specification.new do |s|
  s.name        = "keys"
  s.version     = Keys::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/keys"
  s.summary =  "Search vim keys with great precision"
  s.description = "Search your vim keybindings precisely by keystroke, mode, description or where they came from. Uses index.txt and :map to populate key database."
  s.required_rubygems_version = ">= 1.3.6"
  s.executables        = %w(keys)
  s.add_dependency 'thor', '~> 0.14.6'
  s.add_dependency 'hirb', '~> 0.5.0'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc,md} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.files += Dir.glob(['man/*', '*.gemspec'])
  s.extra_rdoc_files = ["README.md", "LICENSE.txt"]
  s.license = 'MIT'
end
