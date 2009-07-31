require 'nuggets/array/variance'

describe Array, 'when extended by', Nuggets::Array::VarianceMixin do

  it { Array.ancestors.should include(Nuggets::Array::VarianceMixin) }

  example do
    [].variance.should == 0.0
  end

  example do
    [1].variance.should == 0.0
  end

  example do
    [1, 1, 1].variance.should == 0.0
  end

  example do
    [1, 2, 3].variance.should == 2 / 3.0
  end

  example do
    [3, 2, 1].variance.should == 2 / 3.0
  end

  example do
    [-3, -2, -1].variance.should == [3, 2, 1].variance
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].variance.should be_close(42.0, 0.1)
  end

end
