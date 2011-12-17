gem 'minitest' unless ENV['NO_RUBYGEMS']
require 'minitest/autorun'
require 'vimdb'
require 'fileutils'
require 'bahia'

ENV['VIMDB_RC'] = File.dirname(__FILE__) + '/.vimdbrc'
ENV['VIMDB_DB'] = File.dirname(__FILE__) + '/vimdb.pstore'
ENV['VIMDB_FIXTURE_DIR'] = File.dirname(__FILE__) + '/fixtures'

class MiniTest::Unit::TestCase
  include Bahia
end

MiniTest::Unit.after_tests { FileUtils.rm_f(ENV['VIMDB_DB']) }
