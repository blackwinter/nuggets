require 'nuggets/array/regression'

describe Array, 'when extended by', Nuggets::Array::RegressionMixin do

  it { Array.ancestors.should include(Nuggets::Array::RegressionMixin) }

  example {
    [].linear_least_squares.should == []
  }

  example {
    [0].linear_least_squares.should == [[1, 0]]
  }

  example {
    [1].linear_least_squares.should == [[1, 1]]
  }

  example {
    [1, 1].linear_least_squares.should == [[1, 1], [2, 1]]
  }

  example {
    [1, 2, 3, 4].linear_least_squares.should == [[1, 1], [2, 2], [3, 3], [4, 4]]
  }

  example {
    [1, 2, 4, 1].linear_least_squares.should == [[1, 1.7], [2, 1.9], [3, 2.1], [4, 2.3]]
  }

  example {
    r = [2.3, 1.6, 0.9, 0.2]

    [1, 2, 4, -2].linear_least_squares.each_with_index { |(x, y), i|
      x.should == i + 1
      y.should equal_float(r[i])
    }
  }

end
