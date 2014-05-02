require 'nuggets/array/hashify'

describe_extended Array, Nuggets::Array::HashifyMixin do

  example do
    hash = [1, 2, 3, 4].hashify
    hash.should == { 1 => 1, 2 => 2, 3 => 3, 4 => 4 }
    hash[42].should be_nil
  end

  example do
    [1, 2, 3, 4].hashify { |i| [i, i ** 2] }.should == { 1 => 1, 2 => 4, 3 => 9, 4 => 16 }
  end

  example do
    [1, 2, 3, 4].hashify { |i| [i ** 2, i] }.should == { 1 => 1, 4 => 2, 9 => 3, 16 => 4 }
  end

  example do
    lambda { [1, 2, 3, 4].hashify { |i| i } }.should raise_error(ArgumentError)
  end

  example do
    hash = [1, 2, 3, 4].hashify(0)
    hash.should == { 1 => 1, 2 => 2, 3 => 3, 4 => 4 }
    hash[42].should == 0
  end

  example do
    hash = [1, 2, 3, 4].hashify(lambda { |h, k| h[k] = [] })
    hash.should == { 1 => 1, 2 => 2, 3 => 3, 4 => 4 }
    hash[42].should == []
  end

  example do
    hash = [1, 2, 3, 4].hashify(4 => -1, 23 => 42)
    hash.should == { 1 => 1, 2 => 2, 3 => 3, 4 => 4, 23 => 42 }
    hash[42].should be_nil
  end

end
