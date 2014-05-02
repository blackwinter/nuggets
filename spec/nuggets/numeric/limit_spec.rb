require 'nuggets/numeric/limit'

describe Numeric, 'limit' do

  {
    123   => 10,
    -123  =>  0,
    0     =>  0,
    0.001 =>  0.001,
    1.23  =>  1.23,
    -12.3 => 0
  }.each { |n, m|
    example { n.between(0, 10).should == m }
  }

end
