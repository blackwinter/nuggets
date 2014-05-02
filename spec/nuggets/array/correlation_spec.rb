require 'nuggets/array/correlation'

describe_extended Array, Nuggets::Array::CorrelationMixin do

  example do
    [].correlation_coefficient.should == 0.0
  end

  example do
    [1].correlation_coefficient.should == 1.0
  end

  example do
    [1, 1, 1].correlation_coefficient.should == 1.0
  end

  example do
    [1, 2, 3].correlation_coefficient.should == 1.0
  end

  example do
    [-1, -2, -3].correlation_coefficient.should == -1.0
  end

  example do
    [1, 1.5, 2].correlation_coefficient.should == 1.0
  end

  example do
    [3, 2, 1].correlation_coefficient.should == -1.0
  end

  example do
    [-3, -2, -1].correlation_coefficient.should == -[3, 2, 1].correlation_coefficient
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].correlation_coefficient.should equal_float(0.478471417102228)
  end

  example do
    [[1, 1]].correlation_coefficient.should == 1.0
  end

  example do
    [[1, 1], [1, 1], [1, 1]].correlation_coefficient.should == 1.0
  end

  example do
    [[-1, 1], [-1, 1], [-1, 1]].correlation_coefficient.should == 1.0
  end

  example do
    [[1, -1], [1, -1], [1, -1]].correlation_coefficient.should == 1.0
  end

  example do
    [[1, 1], [1, 2], [1, 3]].correlation_coefficient.should == 1.0
  end

  example do
    [[1, 1], [2, 1], [3, 1]].correlation_coefficient.should == 1.0
  end

  example do
    [[-1, 1], [-2, 1], [-3, 1]].correlation_coefficient.should == 1.0
  end

  example do
    [[1, -1], [2, -1], [3, -1]].correlation_coefficient.should == 1.0
  end

  example do
    [[3, 1], [2, 2], [1, 3]].correlation_coefficient.should == -1.0
  end

  example do
    [[-3, 3], [-2, 2], [-1, 1]].correlation_coefficient.should == -[[3, 3], [2, 2], [1, 1]].correlation_coefficient
  end

end
