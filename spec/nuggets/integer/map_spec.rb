require 'nuggets/integer/map'

describe Integer, 'when extended by', Nuggets::Integer::MapMixin do

  it { Integer.ancestors.should include(Nuggets::Integer::MapMixin) }

  {
    0           => 1,
    1           => 2,
    -1          => 3,
    123         => 246,
    -123        => 247,
    1_000_000   => 2_000_000,
    -1_000_000  => 2_000_001,
    10 ** 48    => 2_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000,
    -(10 ** 48) => 2_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_001
  }.each { |int, map|
    example { int.map_positive.should == map }
  }

end
