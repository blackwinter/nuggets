require 'nuggets/numeric/signum'

describe Numeric, 'signum' do

  {
    123   =>  1,
    -123  => -1,
    0     =>  0,
    1     =>  1,
    -1    => -1,
    0.001 =>  1,
    1.23  =>  1,
    -12.3 => -1
  }.each { |n, s| example { n.sign.should == s } }

  {
    123   => '+',
    -123  => '-',
    0     => '+',
    1     => '+',
    -1    => '-',
    0.001 => '+',
    1.23  => '+',
    -12.3 => '-'
  }.each { |n, s| example { n.sign_s.should == s } }

end
