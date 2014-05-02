require 'nuggets/object/boolean'

describe_extended Object, Nuggets::Object::BooleanMixin do

  [0, 1, -1, nil, '', 'abc', Class, Object.new].each { |o|
    example { o.should_not be_boolean }
  }

  [true, false].each { |o|
    example { o.should be_boolean }
  }

  [0, 1, -1, '', 'abc', Class, Object.new, true].each { |o|
    example { o.negate.should == false }
    example { o.to_bool.should == true }
  }

  [nil, false].each { |o|
    example { o.negate.should == true }
    example { o.to_bool.should == false }
  }

end
