require 'nuggets/string/camelscore'

describe_extended String, Nuggets::String::CamelscoreMixin do

  def self.with_acronyms(acronyms, &block)
    describe "with acronyms #{acronyms.inspect}" do
      before :all do ::String::CAMELSCORE_ACRONYMS.replace(acronyms) end
      after  :all do ::String::CAMELSCORE_ACRONYMS.clear             end

      instance_eval(&block)
    end
  end

  with_acronyms({}) { [
    ['', ''],
    %w[a A],
    %w[a_b AB],
    %w[a_b_c ABC],
    %w[a/b A::B],
    %w[a/b_c A::BC],
    %w[a/b/c A::B::C],
    %w[foo Foo],
    %w[foo_bar FooBar],
    %w[foo_bar_baz FooBarBaz],
    %w[foo/bar Foo::Bar],
    %w[foo/bar_baz Foo::BarBaz],
    %w[foo/bar/baz Foo::Bar::Baz],
    %w[active_model ActiveModel],
    %w[active_model/errors ActiveModel::Errors],
    %w[ssl_error SslError],
    %w[s_s_l_error SSLError]
  ].each { |a, b|
    example { a.camelcase.should == b }
    example { b.underscore.should == a }
  } }

  with_acronyms('ab' => 'AB') {
    example { 'ab'.camelcase.should == 'AB' }
    example { 'AB'.underscore.should == 'ab' }
    example { 'abc'.camelcase.should == 'Abc' }
    example { 'Abc'.underscore.should == 'abc' }
    example { 'ab_c'.camelcase.should == 'ABC' }
    example { 'ABC'.underscore.should == 'ab_c' }
  }

  with_acronyms('abc' => 'ABC') {
    example { 'ab'.camelcase.should == 'Ab' }
    example { 'AB'.underscore.should == 'a_b' }
    example { 'abc'.camelcase.should == 'ABC' }
    example { 'ABC'.underscore.should == 'abc' }
  }

  with_acronyms('ab' => 'AB', 'abc' => 'ABC') {
    example { 'ab'.camelcase.should == 'AB' }
    example { 'AB'.underscore.should == 'ab' }
    example { 'abc'.camelcase.should == 'ABC' }
    example { 'Abc'.underscore.should == 'abc' }
    example { 'ab_c'.camelcase.should == 'ABC' }
    example { 'ABC'.underscore.should == 'ab_c' }
  }

  with_acronyms('xml' => 'XML', 'html' => 'HTML', 'sql' => 'SQL') {
    example { 'xml'.camelcase.should == 'XML' }
    example { 'XML'.underscore.should == 'xml' }
    example { 'html'.camelcase.should == 'HTML' }
    example { 'HTML'.underscore.should == 'html' }
    example { 'html5'.camelcase.should == 'HTML5' }
    example { 'HTML5'.underscore.should == 'html5' }
   #pending { 'xhtml'.camelcase.should == 'XHTML' }
   #pending { 'XHTML'.underscore.should == 'xhtml' }
    example { 'sql'.camelcase.should == 'SQL' }
    example { 'SQL'.underscore.should == 'sql' }
   #pending { 'mysql'.camelcase.should == 'MySQL' }
   #pending { 'MySQL'.underscore.should == 'mysql' }
   #pending { 'postgresql'.camelcase.should == 'PostgreSQL' }
   #pending { 'PostgreSQL'.underscore.should == 'postgresql' }
   #pending { 'sqlite'.camelcase.should == 'SQLite' }
   #pending { 'SQLite'.underscore.should == 'sqlite' }
   #pending { 'nosql'.camelcase.should == 'NoSQL' }
   #pending { 'NoSQL'.underscore.should == 'nosql' }
  }

  with_acronyms('rss' => 'RSS', 'xml' => 'XML') {
    example { 'rss2xml'.camelcase.should == 'RSS2XML' }
    example { 'RSS2XML'.underscore.should == 'rss2xml' }
  }

  with_acronyms('ssl' => 'SSL') {
    example { 'ssl'.camelcase.should == 'SSL' }
    example { 'SSL'.underscore.should == 'ssl' }
    example { 'ssl_error'.camelcase.should == 'SSLError' }
    example { 'SSLError'.underscore.should == 'ssl_error' }
  }

  example { ''.constantize.should be_nil }
  example { '::'.constantize.should be_nil }

  example { 'Nuggets'.constantize.should == ::Nuggets }
  example { '::Nuggets'.constantize.should == ::Nuggets }

  example { 'Nuggets::String'.constantize.should == ::Nuggets::String }
  example { '::Nuggets::String'.constantize.should == ::Nuggets::String }

  example { 'String'.constantize.should == ::String }
  example { 'String'.constantize(::Nuggets).should == ::Nuggets::String }
  example { '::String'.constantize(::Nuggets).should == ::String }
  example { 'String'.constantize(::Nuggets::String).should == ::String }
  example { 'String'.constantize(::Nuggets::String::CamelscoreMixin).should == ::String }

  example { lambda { 'CamelscoreMixin'.constantize }.should raise_error(NameError) }
  example { lambda { 'CamelscoreMixin'.constantize(::Nuggets) }.should raise_error(NameError) }
  example { 'CamelscoreMixin'.constantize(::Nuggets::String).should == ::Nuggets::String::CamelscoreMixin }

end
