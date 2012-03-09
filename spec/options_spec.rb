require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "vimdb options" do
  it "lists all options by default" do
    vimdb 'options'
    stdout.must_match /359 rows/
  end

  it 'searches :name field by default' do
    vimdb "options wildignorec"
    stdout.must_match /1 row/
  end
end
