
require 'helper'
require 'rr'

describe PryClipboard::Command do
  extend RR::Adapters::RRMethods

  before do
    Pry.history.clear
    RR.reset
  end

  after do
    RR.verify
  end

  it "#paste" do
    mock(Clipboard).paste { '3 * 3' }
    mock_pry(*%w(
      paste
    )).should =~ /Paste from clipboard.*\n3 \* 3\n=> 9/
  end

  it "#paste -q" do
    mock(Clipboard).paste { '3 * 3' }
    mock_pry(*%w(
      paste\ -q
    )).should.not =~ /Paste from clipboard/
  end

  it "#copy-history" do
    mock(Clipboard).copy <<EOF
'abc'
EOF
    mock(Clipboard).copy <<EOF
"efg"
EOF

    mock_pry(*%w(
      'abc'
      copy-history
    )).should =~ /clipboard.*\n'abc'\n/

    mock_pry(*%w(
      'abc'
      "efg"
      copy-history
    )).should =~ /clipboard.*\n"efg"\n/
  end

  it "#copy-history 2" do
    mock_pry(*%w(
      'foo'
      'bar'
      'baz'
      copy-history\ 2
    )).should =~ /clipboard.*\n'bar'\n/
  end

  it "#copy-history -l" do
    mock(Clipboard).copy("10 * 10\n#=> 100\n")
    mock_pry(*%w(
      10\ *\ 10
      copy-history\ -l
    )).should =~ /clipboard.*\n10 \* 10\n#=> 100\n/
  end

  it "#copy-history -q" do
    mock(Clipboard).copy <<EOF
'abc'
EOF
    mock(Clipboard).copy <<EOF
"efg"
EOF

    mock_pry(*%w(
      'abc'
      copy-history\ -q
    )).should.not =~ /clipboard.*\n'abc'\n/

    mock_pry(*%w(
      'abc'
      "efg"
      copy-history\ -q
    )).should.not =~ /clipboard.*\n"efg"\n/
  end

  it "#copy-history --head 3" do
    mock(Clipboard).copy <<EOF
1
2
3
EOF
    mock_pry(*%w(
      1
      2
      3
      4
      5
      copy-history\ --head\ 3
    )).should =~ /clipboard/
  end

  it "#copy-history --tail 3" do
    mock(Clipboard).copy <<EOF
3
4
5
EOF
    mock_pry(*%w(
      1
      2
      3
      4
      5
      copy-history\ --tail\ 3
    )).should =~ /clipboard/
  end

  it "#copy-history --range 2..4" do
    mock(Clipboard).copy <<EOF
2
3
4
EOF
    mock_pry(*%w(
      1
      2
      3
      4
      5
      copy-history\ --range\ 2..4
    )).should =~ /clipboard/
  end

  it "#copy-history --grep foo" do
    mock(Clipboard).copy <<EOF
'foo'
'foobar'
EOF
    mock_pry(*%w(
      1
      'foo'
      'foobar'
      'baz'
      copy-history\ --grep\ foo)
    ).should =~ /clipboard/
  end

  it "#copy-history --range 1..2 --grep foo" do
    mock(Clipboard).copy <<EOF
'foo'
EOF
    mock_pry(*%w(
      1
      'foo'
      'foobar'
      'baz'
      copy-history\ --range\ 1..2\ --grep\ foo)
    ).should =~ /clipboard/
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
