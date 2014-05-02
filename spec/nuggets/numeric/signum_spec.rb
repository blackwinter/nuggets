require 'nuggets/numeric/signum'

describe Numeric, 'signum' do

  {
    123   =>  1,
    -123  => -1,
    0     =>  0,
    0.001 =>  1,
    1.23  =>  1,
    -12.3 => -1
  }.each { |n, s|
    example { n.sign.should == s }
  }

end
