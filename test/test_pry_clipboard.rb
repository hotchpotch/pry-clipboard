
require 'helper'
require 'rr'

describe PryClipboard::Command do
  extend RR::Adapters::RRMethods

  before do
    RR.reset
  end

  after do
    RR.verify
  end

  it "#copy-history" do
    mock(Clipboard).copy("'abc'\n")
    mock(Clipboard).copy("'efg'\n")
    mock_pry("'abc'", "copy-history").should =~ /clipboard.*\n'abc'\n/
    mock_pry("'abc'", "'efg'", "copy-history").should =~ /clipboard.*\n'efg'\n/
  end

  it "#copy-history -r" do
    mock(Clipboard).copy("10 * 10\n#=> 100\n")
    mock_pry("10 * 10", "copy-history -r").should =~ /clipboard.*\n10 \* 10\n#=> 100\n/
  end

  it "#copy-history -q" do
    mock(Clipboard).copy("'abc'\n")
    mock(Clipboard).copy("'efg'\n")
    mock_pry("'abc'", "copy-history -q").should.not =~ /clipboard.*\n'abc'\n/
    mock_pry("'abc'", "'efg'", "copy-history -q").should.not =~ /clipboard.*\n'efg'\n/
  end


  it "#copy-result" do
    mock(Clipboard).copy("1000\n")
    mock_pry("10 * 10 * 10", "copy-result").should =~ /clipboard.*\n1000\n/
  end

  it "#copy-result -q" do
    mock(Clipboard).copy("1000\n")
    mock_pry("10 * 10 * 10", "copy-result -q").should.not =~ /clipboard.*\n1000\n/
  end
end
