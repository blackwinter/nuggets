require 'nuggets/numeric/duration'

describe Numeric, 'duration' do

  {
    123        => [[[    0,  2,  3],                 '2m3s',        '2m3.00s'],        [[0,  0, 0.0014236111111111112],  '0d',      '0d 2m3s']],
    123456789  => [[[34293, 33,  9],                 '34293h33m9s', '34293h33m9.00s'], [[3, 11, 3.1480208333333333],     '3y11m3d', '3y11m3d 3h33m9s']],
    0          => [[[    0,  0,  0],                 '0s',          '0.00s'],          [[0,  0, 0.0],                    '0d',      '0d 0s']],
    0.001      => [[[    0,  0,  0.001],             '0s',          '0.00s'],          [[0,  0, 1.1574074074074074e-08], '0d',      '0d 0s']],
    1.23       => [[[    0,  0,  1.23],              '1s',          '1.23s'],          [[0,  0, 1.4236111111111111e-05], '0d',      '0d 1s']],
    1234.56789 => [[[    0, 20, 34.567890000000034], '20m35s',      '20m34.57s'],      [[0,  0, 0.014288980208333333],   '0d',      '0d 20m35s']]
  }.each { |n, (h, y)|
    example { [n.hms, n.to_hms, n.to_hms(2)].should == h }
    example { [n.ymd, n.to_ymd, n.to_ymd(true)].should == y }
  }

  example {
    lambda { -1.hms }.should raise_error(ArgumentError, 'negative duration -1')
  }

  example {
    lambda { -1.ymd }.should raise_error(ArgumentError, 'negative duration -1')
  }

end
