require 'nuggets/array/regression'

describe_extended Array, Nuggets::Array::RegressionMixin do

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

  [
    [],
    [0],
    [1, 1],
    [1, 2, 4, -2],
    [2.3, 1.6, 0.9, 0.2],
    [1, 2, -1, 3, -2, 4, -3]
  ].each { |a|
    example {
      a.llsq.zip(a.llsqi.to_a).each { |(x1, y1), (x2, y2)|
        x1.should == x2
        y1.should equal_float(y2)
      }
    }
  }

end
