require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "vimdb keys" do
  it "lists all keys by default" do
    vimdb 'keys'
    stdout.must_match /903 rows/
  end

  it 'searches :key field by default' do
    vimdb 'keys', 'g#'
    stdout.must_match /1 row/
  end

  it 'with --mode option ANDs mode to search' do
    vimdb 'keys', 'gm', '-m=n'
    stdout.must_match /1 row/
  end

  describe "edge cases" do
    it "converts control key to C-" do
      vimdb 'keys', 'C-z'
      stdout.wont_match /0 rows/
      stdout.must_match /C-z/
    end

    it "converts escape key to E-" do
      vimdb 'keys', 'E-x'
      stdout.wont_match /0 rows/
      stdout.must_match /E-x/
    end

    it 'converts leader key to L-' do
      vimdb 'keys', 'L-z'
      stdout.must_match /1 row/
    end

    it 'searches non-alphabetic characters' do
      vimdb 'keys', '!'
      stdout.must_match /!\{filter\}/
    end

    it "lists plugin keys with plugin name" do
      vimdb 'keys'
      stdout.must_match /command-t plugin/
    end

    it 'lists user-generated keys' do
      vimdb 'keys', 'L-w'
      stdout.must_include <<-STR.sub(/^\s+/, '')
      | L-w | nvso | user | :call OpenURL()<CR> |
      STR
    end

    it "doesn't list Plug keys" do
      vimdb 'keys', 'Plug'
      stdout.must_match /0 rows/
    end
  end
end
