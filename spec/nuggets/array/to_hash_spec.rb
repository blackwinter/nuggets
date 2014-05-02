require 'nuggets/array/to_hash'

describe Array, 'to_hash' do

  example {
    a = [[:a, 1], [:b, 2], [:c, 3]]
    a.to_h.should == { a: 1, b: 2, c: 3 }
  }

  example {
    a = [[:a, [1, 2]], [:b, 3], [[:c, :d], [4, [5, 6]]]]
    a.to_h.should == { a: [1, 2], b: 3, [:c, :d] => [4, [5, 6]] }
  }

  example {
    a = %w[a b c d]

    a.to_h.should == { 'a' => 'b', 'c' => 'd' }
    a.to_h(1).should == { 'a' => 1, 'b' => 1, 'c' => 1, 'd' => 1 }
    a.to_h { nil }.should == { 'a' => nil, 'b' => nil, 'c' => nil, 'd' => nil }
  }

  example {
    h = { a: 1, b: [2, 3], c: { d: 4 } }
    h.to_a.to_h.should == h
  }

end
