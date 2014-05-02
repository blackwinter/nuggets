require 'nuggets/array/histogram'

describe_extended Array, Nuggets::Array::HistogramMixin do

  example do
    [].histogram.should == {}
  end

  example do
    [1].histogram.should == { 1 => 1 }
  end

  example do
    [1, 1, 1].histogram.should == { 1 => 3 }
  end

  example do
    [1, 2, 2, 3].histogram.should == { 1 => 1, 2 => 2, 3 => 1 }
  end

  example do
    [3, 2, 2, 1].histogram.should == [1, 2, 2, 3].histogram
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].histogram.should == {
      -4 => 1, -2 => 1, 0 => 2, 1 => 4, 2 => 2, 3 => 2, 24 => 1
    }
  end

  example do
    %w[one two three three].histogram.should == { 'one' => 1, 'two' => 1, 'three' => 2 }
  end

  example do
    %w[three two one three].histogram.should == %w[one two three three].histogram
  end

  example do
    [1, 2, 2, 3, 4].histogram { |x| x * 2 }.should == { 2 => 1, 4 => 2, 6 => 1, 8 => 1 }
  end

  example do
    [1, 2, 3, 4].histogram { |x| x / 2 }.should == { 0 => 1, 1 => 2, 2 => 1 }
  end

  example do
    [].probability_mass_function.should == {}
  end

  example do
    [1].probability_mass_function.should == { 1 => 1 }
  end

  example do
    [1, 1, 1].probability_mass_function.should == { 1 => 1 }
  end

  example do
    [1, 2, 2, 3].probability_mass_function.should == { 1 => 0.25, 2 => 0.5, 3 => 0.25 }
  end

  example do
    [3, 2, 2, 1].probability_mass_function.should == [1, 2, 2, 3].probability_mass_function
  end

  example do
    [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].probability_mass_function.values.inject(:+).should equal_float(1.0)
  end

  example do
    %w[one two three three].probability_mass_function.should == { 'one' => 0.25, 'two' => 0.25, 'three' => 0.5 }
  end

  example do
    %w[three two one three].probability_mass_function.should == %w[one two three three].probability_mass_function
  end

  example do
    [1, 2, 2, 3, 4].probability_mass_function { |x| x * 2 }.should == { 2 => 0.2, 4 => 0.4, 6 => 0.2, 8 => 0.2 }
  end

  example do
    [1, 2, 3, 4].probability_mass_function { |x| x / 2 }.should == { 0 => 0.25, 1 => 0.5, 2 => 0.25 }
  end

end
