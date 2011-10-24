require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "vimdb commands" do
  it "lists all commands by default" do
    vimdb 'commands'
    stdout.must_match /643 rows/
  end

  it "searches :name field by default" do
    vimdb 'commands', 'bufd'
    stdout.must_match /1 row/
  end

  it 'lists command names without symbol' do
    vimdb 'commands', 'bad'
    stdout.must_include <<-STR
| bad[d] | add buffer to the buffer list | default |
STR
  end

  it 'lists multi-line index commands correctly' do
    vimdb 'commands', 'wp'
    stdout.must_include <<-STR
| wp[revious] | write to a file and go to previous file in argument list | default |
STR
  end
end
