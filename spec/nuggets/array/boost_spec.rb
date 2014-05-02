require 'nuggets/array/boost'

describe_extended Array, Nuggets::Array::BoostMixin do

  example {
    lambda { [].boost_factor([]) }.should raise_error(NoMethodError)
  }

  example {
    lambda { [1].boost_factor([]) }.should raise_error(NoMethodError)
  }

  example {
    lambda { [].boost_factor([1]) }.should raise_error(TypeError)
  }

  example {
    a, b = [0].boof([0]), Float::NAN

    a.class.should == b.class
    a.to_s.should == b.to_s
  }

  example {
    1.step(100, 10) { |i| [i].boof([0]).should == -1 }
  }

  example {
    1.step(100, 10) { |i| [0].boof([i]).should == Float::INFINITY }
  }

  example {
    a, b = [1.5, 1.6, 1.4], [0.7, 0.8, 0.8]

    a.boof(b).should equal_float(-0.48888888888888893)
    a.boof(b, &:max).should equal_float(-0.5)
    a.boof(b, &:geomean).should equal_float(-0.4891270450709646)
    a.boof(b) { |x| x.inject(:-) }.should equal_float(-0.3999999999999999)
  }

  [
    [[1], [1], :mean],
    [[1], [1, 2, 3], :mean],
    [[1.5, 1.6, 1.4], [0.7, 0.8, 0.8], :mean],
    [[1.5, 1.6, 1.4], [0.7, 0.8, 0.8], :geomean]
  ].each { |a, b, m|
    example { a.boost(a.boof(b, &m)).send(m).should equal_float(b.send(m)) }
  }

end
