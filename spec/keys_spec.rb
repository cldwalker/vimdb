require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "vimdb keys" do
  it "lists all keys by default" do
    vimdb 'keys'
    stdout.must_match /903 rows/
  end

  it 'searches :key field by default' do
    vimdb 'keys', 'L-z'
    stdout.must_match /1 row/
  end

  it "with --field option searches another field" do
    vimdb 'keys', 'L-z' ,'-f=desc'
    stdout.must_match /0 rows/
  end

  it "with --reverse_sort option reverse sorts field" do
    vimdb 'keys', '-R'
    stdout.must_match /C-a.*'\]/m
  end

  it "with --regexp option converts search to regexp" do
    vimdb 'keys', '^C-', '-r'
    stdout.wont_match /0 rows/
    stdout.must_match /C-a.*C-z/m
  end

  it "with --ignore-case option ignores case" do
    vimdb 'keys', 'Q:', '-i'
    stdout.must_match /q:.*1 row/m
  end

  it 'with --mode option ANDs mode to search' do
    vimdb 'keys', 'gm', '-m=n'
    stdout.must_match /1 row/
  end

  describe "edge cases" do
    it 'searches non-alphabetic characters' do
      vimdb 'keys', '!'
      stdout.must_match /!\{filter\}/
    end

    it "doesn't list Plug keys" do
      vimdb 'keys', 'Plug'
      stdout.must_match /0 rows/
    end
  end
end
