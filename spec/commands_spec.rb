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
| badd | bad   | default | add buffer to the buffer list |
STR
  end

  it "lists command name without alias" do
    vimdb 'commands', 'bufd'
    stdout.must_include <<-STR
| bufdo |       | default | execute command in each listed buffer |
STR
  end

  it 'lists multi-line index commands correctly' do
    vimdb 'commands', 'wp'
    stdout.must_include <<-STR
| wprevious | wp    | default | write to a file and go to previous file in argument list |
STR
  end

  it "lists user-defined commands correctly" do
    vimdb 'commands', 'GitGrep'
    stdout.must_include <<-STR
| GitGrep |       | user | call GitGrep(<q-args>) |
STR
  end

  it "lists plugin commands correctly" do
    vimdb 'commands', 'Gist'
    stdout.must_include <<-STR
| Gist |       | gist-vim plugin | :call Gist(<line1>, <line2>, <f-args>) |
STR
  end
end
