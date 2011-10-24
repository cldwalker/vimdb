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

  it 'lists command names without symbol and alias' do
    vimdb 'commands', 'bad'
    stdout.must_include <<-STR
| badd | bad   | default | add buffer to the buffer list |
STR
  end

  it 'lists multi-line index commands correctly' do
    vimdb 'commands', 'wp'
    stdout.must_include <<-STR
| wprevious | wp    | default | write to a file and go to previous file in argument list |
STR
  end
end
