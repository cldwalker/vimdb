# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/vimdb/version"

Gem::Specification.new do |s|
  s.name        = "vimdb"
  s.version     = Vimdb::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/vimdb"
  s.summary =  "vim knowledge tabularized - search vim keys, options and more with great precision."
  s.description = "Search your vim keybindings precisely by keystroke, mode, description or where they came from. Search vim options by name, alias and description."
  s.required_rubygems_version = ">= 1.3.6"
  s.executables        = %w(vimdb)
  s.add_dependency 'boson', '>= 1.1.1'
  s.add_dependency 'hirb', '~> 0.6.0'
  s.add_development_dependency 'minitest', '~> 2.5.1'
  s.add_development_dependency 'bahia', '~> 0.3.0'
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc,md} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec .travis.yml}
  s.files += Dir.glob(['spec/fixtures/*', 'spec/.vimdbrc'])
  s.extra_rdoc_files = ["README.md", "LICENSE.txt"]
  s.license = 'MIT'
end
