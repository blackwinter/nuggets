require 'nuggets/array/standard_deviation'

describe_extended Array, Nuggets::Array::StandardDeviationMixin do

  example do
    [].standard_deviation.should == 0.0
  end

  example do
    [1].standard_deviation.should == 0.0
  end

  example do
    [1, 1, 1].standard_deviation.should == 0.0
  end

  example do
    [1, 2, 3].standard_deviation.should equal_float(0.816496580927726)
  end

  example do
    [3, 2, 1].standard_deviation.should equal_float(0.816496580927726)
  end

  example do
    [-3, -2, -1].standard_deviation.should == [3, 2, 1].standard_deviation
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].standard_deviation.should equal_float(6.48804088737217)
  end

end
