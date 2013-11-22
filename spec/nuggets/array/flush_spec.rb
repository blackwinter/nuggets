require 'nuggets/array/flush'

describe Array, 'when extended by', Nuggets::Array::FlushMixin do

  it { Array.ancestors.should include(Nuggets::Array::FlushMixin) }

  example do
    a = [1, 2, 3, 4]
    a.flush.should == [1, 2, 3, 4]
    a.should be_empty
  end

  example do
    a = [1, 2, 3, 4]
    a.flush.push(42).should == [1, 2, 3, 4, 42]
    a.should be_empty
  end

  example do
    a = [1, 2, 3, 4]
    a.flush { |b| b.should == [1, 2, 3, 4]; 42 }.should == 42
    a.should be_empty
  end

  example do
    a = [1, 2, 3, 4]
    a.flush { |b| b }.should be_empty
    a.should be_empty
  end

  example do
    a, c = [1, 2, 3, 4], nil
    a.flush { |b| c = b; c.should == [1, 2, 3, 4] }
    a.should be_empty
    c.should be_empty
  end

  example do
    a, c = [1, 2, 3, 4], nil
    a.flush { |b| c = b.dup; c.should == [1, 2, 3, 4] }
    a.should be_empty
    c.should == [1, 2, 3, 4]
  end

end
