require 'nuggets/object/msend'

describe_extended Object, Nuggets::Object::MSendMixin do

  example do
    o = 'foo bar'
    o.msend(:length, :reverse).should == [o.length, o.reverse]
  end

  example do
    o = 42
    o.msend(:to_s, :* => 2).should == [o.to_s, o * 2]
  end

  example do
    o = 42
    o.msend([:to_s, 2], '-@').should == [o.to_s(2), -o]
  end

  example do
    o = Time.now
    o.msend(:year, :month, :day).should == [o.year, o.month, o.day]
  end

end
