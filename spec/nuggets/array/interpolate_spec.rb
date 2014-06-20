require 'nuggets/array/interpolate'

describe_extended Array, Nuggets::Array::InterpolateMixin do

  {
    []                                                       => [],
    [0]                                                      => [0],
    [nil]                                                    => [0],
    [0, nil]                                                 => [0, 0],
    [1, nil, 3]                                              => [1, 2, 3],
    [1, nil, 3, nil]                                         => [1, 2, 3, 1.5],
    [1, nil, nil, 4]                                         => [1, 2, 3, 4],
    [1, nil, 3, nil, 5]                                      => [1, 2, 3, 4, 5],
    [1, nil, nil, 4, 5]                                      => [1, 2, 3, 4, 5],
    [1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 11]     => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    [1, nil, nil, nil, nil, 11, nil, nil, nil, nil, 11]      => [1, 3, 5, 7, 9, 11, 11, 11, 11, 11, 11],
    [1, 2, 3, nil, nil, 4, 5, nil, 6, nil, nil, nil, 7, nil] => [1, 2, 3, 3.3333333333333335, 3.6666666666666665, 4, 5, 5.5, 6, 6.25, 6.5, 6.75, 7, 3.5]
  }.each { |a, b| example { a.interpolate.should == b } }

  {
    []                                                       => [],
    [0]                                                      => [0],
    [nil]                                                    => [nil],
    [0, nil]                                                 => [0, nil],
    [1, nil, 3]                                              => [1, 2, 3],
    [1, nil, 3, nil]                                         => [1, 2, 3, nil],
    [1, nil, nil, 4]                                         => [1, 2, 3, 4],
    [1, nil, 3, nil, 5]                                      => [1, 2, 3, 4, 5],
    [1, nil, nil, 4, 5]                                      => [1, 2, 3, 4, 5],
    [1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 11]     => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    [1, nil, nil, nil, nil, 11, nil, nil, nil, nil, 11]      => [1, 3, 5, 7, 9, 11, 11, 11, 11, 11, 11],
    [1, 2, 3, nil, nil, 4, 5, nil, 6, nil, nil, nil, 7, nil] => [1, 2, 3, 3.3333333333333335, 3.6666666666666665, 4, 5, 5.5, 6, 6.25, 6.5, 6.75, 7, nil]
  }.each { |a, b| example { a.interpolate(nil).should == b } }

  example { [nil].interpolate(42).should == [42] }

  example { [nil].interpolate(40, 44).should == [42] }

  example { [nil, nil, nil, nil, 5].interpolate.should == [1, 2, 3, 4, 5] }

  example { [nil, nil, nil, nil, 5].interpolate(10).should == [9, 8, 7, 6, 5] }

  example { [nil, nil, nil, nil, 5, nil, nil, nil, nil].interpolate(10, 0).should == [9, 8, 7, 6, 5, 4, 3, 2, 1] }

end
