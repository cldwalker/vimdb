require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'tempfile'

describe Vimdb::Runner do
  describe "commands" do
    it "--help prints help" do
      vimdb '--help'
      stdout.must_match /^Usage: vimdb COMMAND.*commands.*keys.*options/m
    end

    it "no arguments prints help" do
      vimdb
      stdout.must_match /^Usage: vimdb COMMAND.*commands.*keys.*options/m
    end

    Vimdb::Item.all.each do |item|
      it "info for #{item} prints info" do
        vimdb "info #{item}"
        stdout.must_match /^Created/
      end
    end
  end

  describe "rc file" do
    before {
      @old_rc = ENV['VIMDB_RC']
      ENV['VIMDB_RC'] = Tempfile.new(Time.now.to_i.to_s).path
    }
    after  { ENV['VIMDB_RC'] = @old_rc }

    def rc_contains(str)
      File.open(ENV['VIMDB_RC'], 'w') {|f| f.write str }
    end

    it "loads user-defined commands" do
      rc_contains <<-RC
      class Vimdb::Runner
        desc 'some task'
        def new_task(arg); end
      end
      RC

      vimdb "new_task -h"
      stdout.must_match /^Usage: vimdb new_task ARG/
    end

    it "can be nonexistent" do
      vimdb
      process.success?.must_equal true
    end

    it "prints error when it fails to load" do
      rc_contains 'FUUUU!'
      vimdb
      stderr.must_match /Error while loading/
    end
  end
end
