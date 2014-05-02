require 'nuggets/integer/factorial'

describe Integer, 'factorial' do

  { 1 => 1, 2 => 2, 3 => 6, 4 => 24, 5 => 120, 6 => 720 }.each { |i, j|
    example { i.factorial.should == j }
    example { i.factorial_memoized.should == j }
  }

end
