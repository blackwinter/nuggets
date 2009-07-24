require 'nuggets/hash/unroll'

describe Hash, 'when extended by', Nuggets::Hash::UnrollMixin do

  it { Hash.ancestors.should include(Nuggets::Hash::UnrollMixin) }

  example do
    {}.unroll.should == [[]]
  end

  example do
    { :a => 1 }.unroll.should == [[1]]
  end

  example do
    { :a => { :b => 1 } }.unroll.should == [[:a, 1]]
  end

  example do
    { :a => { :b => 1, :c => 2 } }.unroll(&:to_s).should == [[:a, 1, 2]]
  end

  example do
    { :a => { :b => 1, :c => 2 }, :d => { :b => 0, :c => 3 } }.unroll(:b, :c, &:to_s).should == [[:a, 1, 2], [:d, 0, 3]]
  end

  example do
    { :z => { :a => { :b => 1, :c => 2 }, :d => { :b => 0, :c => 3 } } }.unroll(:b, &:to_s).should == [[:z, :a, 1], [:z, :d, 0]]
  end

end
