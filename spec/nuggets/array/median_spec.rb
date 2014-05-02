require 'nuggets/array/median'

describe_extended Array, Nuggets::Array::MedianMixin do

  example do
    [].median.should be_nil
  end

  example do
    [1].median.should == 1
  end

  example do
    [1, 1, 1].median.should == 1
  end

  example do
    [1, 2, 3].median.should == 2
  end

  example do
    [3, 2, 1].median.should == 2
  end

  example do
    [-3, -2, -1].median.should == -[3, 2, 1].median
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].median.should == 1
  end

  example do
    [1, 2, 3, 4].median.should == 2.5
  end

  example do
    %w[one two three].median.should == 'three'
  end

  example do
    %w[three two one].median.should == 'three'
  end

  [true, 1, :left].each { |prefer|
    example { [1, 2, 3].median(prefer).should == 2 }
    example { [1, 2, 3, 4].median(prefer).should == 2 }

    example { %w[one two three].median(prefer).should == 'three' }
    example { %w[one two three four].median(prefer).should == 'one' }
  }

  [false, 2, :right].each { |prefer|
    example { [1, 2, 3].median(prefer).should == 2 }
    example { [1, 2, 3, 4].median(prefer).should == 3 }

    example { %w[one two three].median(prefer).should == 'three' }
    example { %w[one two three four].median(prefer).should == 'three' }
  }

  example do
    [1, 2, 3, 4].median { |a, b| a * b }.should == 6
  end

  example do
    %w[one two three four].median { |a, b| b * a.length }.should == 'threethreethree'
  end

  example do
    lambda { %w[one two three four].median }.should raise_error(NoMethodError, %r{undefined method `/' .*String})
  end

  example do
    lambda { [1, 2, 'three'].median }.should raise_error(ArgumentError, /comparison .* failed/)
  end

end
