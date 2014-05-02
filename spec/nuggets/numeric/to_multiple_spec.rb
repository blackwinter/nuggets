require 'nuggets/numeric/to_multiple'

describe Numeric, 'to_multiple' do

  {
    123   => [ 120,  120,  130],
    -123  => [-120, -130, -120],
    0     => [   0,    0,    0],
    0.001 => [   0,    0,   10],
    5.67  => [  10,    0,   10],
    -12.3 => [ -10,  -20,  -10]
  }.each { |n, m|
    example { [n.round_to(10), n.floor_to(10), n.ceil_to(10)].should == m }
  }

end
