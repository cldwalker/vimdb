require 'minitest/autorun'
require 'vimdb'
require 'open3'
require 'fileutils'

ENV['VIMDB_RC'] = File.dirname(__FILE__) + '/.vimdbrc'
ENV['VIMDB_DB'] = File.dirname(__FILE__) + '/vimdb.pstore'
ENV['VIMDB_FIXTURE_DIR'] = File.dirname(__FILE__) + '/fixtures'

module TestHelpers
  attr_reader :stdout, :stderr, :process

  def vimdb(*args)
    args.unshift File.dirname(__FILE__) + '/../bin/vimdb'
    args.unshift({'RUBYLIB' => "#{File.dirname(__FILE__)}/../lib:" +
                 ENV['RUBYLIB']})
    @stdout, @stderr, @process = Open3.capture3(*args)
  end
end

class MiniTest::Unit::TestCase
  include TestHelpers
end

MiniTest::Unit.after_tests { FileUtils.rm_f(ENV['VIMDB_DB']) }
