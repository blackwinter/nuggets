require 'nuggets/hash/unroll'

describe Hash, 'when extended by', Nuggets::Hash::UnrollMixin do

  it { Hash.ancestors.should include(Nuggets::Hash::UnrollMixin) }

  before :each do
    @options = { :sort_by => lambda { |h| h.to_s } }
  end

  example do
    hash = {}
    hash.unroll.should == [[]]
  end

  example do
    hash = { :a => 1 }
    hash.unroll.should == [[1]]
  end

  example do
    hash = { :a => { :b => 1 } }
    hash.unroll.should == [[:a, 1]]
  end

  example do
    hash = { :a => { :b => 1, :c => 2 } }
    hash.unroll(@options).should == [[:a, 1, 2]]
  end

  example do
    hash = { :a => { :b => 1, :c => 2 }, :d => { :b => 0, :c => 3 } }
    hash.unroll(:b, :c, @options).should == [[:a, 1, 2], [:d, 0, 3]]
  end

  example do
    hash = { :z => { :a => { :b => 1, :c => 2 }, :d => { :b => 0, :c => 3 } } }
    hash.unroll(:b, @options).should == [[:z, :a, 1], [:z, :d, 0]]
  end

  example do
    hash = { :z => { :a => { :b => 1, :c => 2 }, :d => { :b => 0, :c => 3 } } }
    hash.unroll(@options) { |h| h[:b] = nil; h[:c] *= 2 }.should == [[:z, :a, nil, 4], [:z, :d, nil, 6]]
  end

end
