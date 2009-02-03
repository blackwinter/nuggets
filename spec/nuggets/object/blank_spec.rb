require 'nuggets/object/blank'

describe Object, 'when extended by', Nuggets::Object::Blank do

  ['s', ' ', 0, 1, true, [nil]].each { |o|
    example { o.should_not be_blank }
  }

  ['', nil, false, [], {}].each { |o|
    example { o.should be_blank }
  }

  ['s', 1, true].each { |o|
    example { o.should_not be_void }
    example { o.should_not be_vain }
  }

  ['', ' ', 0, nil, false, [], [nil], {}].each { |o|
    example { o.should be_void }
    example { o.should be_vain }
  }

  [['', [], [nil], {}], { :x => nil, :y => [], :z => { :zz => nil } }].each { |o|
    example { o.should_not be_void }
  }

  [['', [], [nil], {}], { :x => nil, :y => [], :z => { :zz => nil } }].each { |o|
    example { o.should be_vain }
  }

end
