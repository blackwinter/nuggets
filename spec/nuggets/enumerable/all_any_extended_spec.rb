require 'nuggets/enumerable/all_any_extended'

describe Enumerable, 'all_any_extended' do

  example {
    e = %w[quux quuux quix]

    e.all?(String).should == true
    e.any?(Numeric).should == false
  }

  example {
    e = [:one, 'c', nil, 88]

    e.all?(Object).should == true
    e.any?(NilClass).should == true
  }

  example {
    e = [0, 10, 20]

    e.any?(9..99).should == true
    e.any?(9, :<).should == true
    e.any? { |i| i < 9 }.should == true
  }

  example {
    lambda { [].any?(NilClass, &:nil?) }.should raise_error(ArgumentError, 'both block and object argument given')
  }

end
