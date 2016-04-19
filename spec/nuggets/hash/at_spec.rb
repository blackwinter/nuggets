require 'nuggets/hash/at'

describe Hash, 'at' do

  let(:h) { { a: 1, 2 => 3, nil => nil, 'foo' => %w[b a r] } }

  example { h.first.should == { a: 1 } }

  example { h.last.should == { 'foo' => %w[b a r] } }

  example { h.rand.should be_a(Hash) }

  example { h.at(0).should == { a: 1 } }

  example { h.at(1).should == { 2 => 3 } }

  example { h.at(-1).should == { 'foo' => %w[b a r] } }

end
