require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "common search options" do
  it "with --field option searches another field" do
    vimdb 'keys', 'L-z' ,'-f=desc'
    stdout.must_match /0 rows/
  end

  it "with --reverse_sort option reverse sorts field" do
    vimdb 'keys', '-R'
    stdout.must_match /gq.*'\]/m
  end

  it "with --regexp option converts search to regexp" do
    vimdb 'keys', '^C-', '-r'
    stdout.wont_match /^0 rows/
    stdout.must_match /C-a.*C-z/m
  end

  it "with --ignore-case option ignores case" do
    vimdb 'keys', 'Q:', '-i'
    stdout.must_match /q:.*1 row/m
  end

  it "with --not option returns all non-matching results" do
    vimdb 'keys', 'blarg', '-n'
    stdout.must_match /928 rows/
  end

  it "with --all option searches all fields" do
    vimdb 'keys', 'C', '-a'
    stdout.must_match /365 rows/
    # from desc field
    stdout.must_include ' :TComment<CR>'
  end
end
