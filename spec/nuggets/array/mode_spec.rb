require 'nuggets/array/mode'

describe_extended Array, Nuggets::Array::ModeMixin do

  example do
    [].mode.should be_nil
  end

  example do
    [1].mode.should == 1
  end

  example do
    [1, 1, 1].mode.should == 1
  end

  example do
    [1, 2, 2, 3].mode.should == 2
  end

  example do
    [3, 2, 2, 1].mode.should == 2
  end

  example do
    [-3, -2, -2, -1].mode.should == -[3, 2, 2, 1].mode
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].mode.should == 1
  end

  example do
    [1, 2, 2, 3, 3, 4].modes.should == [2, 3]
  end

  example do
    [2, 3].should include([1, 2, 2, 3, 3, 4].mode)
  end

  example do
    %w[one two three three].mode.should == 'three'
  end

  example do
    %w[three two one three].mode.should == 'three'
  end

  example do
    [1, 2, 2, 3, 4].mode { |x| x * 2 }.should == 4
  end

  example do
    [1, 2, 3, 4].modes { |x| x / 2 }.should == [1]
  end

end
