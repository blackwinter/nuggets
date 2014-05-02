require 'nuggets/string/msub'

describe String, 'msub' do

  let(:s) { 'Foo, Bar - Baz' }

  example { s.gsub(/a/, 'o').gsub(/o/, 'a').should == 'Faa, Bar - Baz' }
  example { s.msub('a' => 'o', 'o' => 'a').should == 'Faa, Bor - Boz' }

  example { s.msub!('a' => 'o', 'o' => 'a'); s.should == 'Faa, Bor - Boz' }

  example { s.msub(/[A-Z]/ => '#{__match__.downcase}', __binding__: binding).should == 'foo, bar - baz' }
  example { s.msub(/[A-Z]/ => lambda { |match| match.downcase }).should == 'foo, bar - baz' }

  t = '!!!'

  example { lambda { s.msub('r' => '???', 'z' => '#{t}') }.should raise_error(NameError) }
  example { s.msub('r' => '???', 'z' => '#{t}', __binding__: binding).should == 'Foo, Ba??? - Ba!!!' }

end
