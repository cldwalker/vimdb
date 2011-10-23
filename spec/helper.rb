require 'minitest/autorun'
require 'vimdb'
require 'open3'

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
