require 'nuggets/hash/unroll'

describe_extended Hash, Nuggets::Hash::UnrollMixin do

  example do
    hash = {}
    hash.unroll.should == [[]]
  end

  example do
    hash = { 'a' => 1 }
    hash.unroll.should == [[1]]
  end

  example do
    hash = { 'a' => { 'b' => 1 } }
    hash.unroll.should == [['a', 1]]
  end

  example do
    hash = { a: { b: 1 } }
    hash.unroll.should == [[:a, 1]]
  end

  example do
    hash = { a: { b: 1, c: 2 } }

    result = hash.unroll.first
    result.size.should == 3

    result.first.should == :a
    result.should include(1)
    result.should include(2)
  end

  example do
    hash = { 'a' => { 'b' => 1, 'c' => 2 } }
    hash.unroll(sort: true).should == [['a', 1, 2]]
  end

  example do
    hash = { 'a' => { 'b' => 1, 'c' => 2 }, 'd' => { 'b' => 0, 'c' => 3 } }
    hash.unroll('b', 'c', sort: true).should == [['a', 1, 2], ['d', 0, 3]]
  end

  example do
    hash = { 'z' => { 'a' => { 'b' => 1, 'c' => 2 }, 'd' => { 'b' => 0, 'c' => 3 } } }
    hash.unroll('b', sort_by: lambda { |h| h.to_s }).should == [['z', 'a', 1], ['z', 'd', 0]]
  end

  example do
    hash = { 'z' => { 'a' => { 'b' => 1, 'c' => 2 }, 'd' => { 'b' => 0, 'c' => 3 } } }
    hash.unroll(sort: true) { |h| h['b'] = nil; h['c'] *= 2 }.should == [['z', 'a', nil, 4], ['z', 'd', nil, 6]]
  end

end
