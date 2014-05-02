require 'nuggets/hash/only'

describe Hash, 'only' do

  example {
    h = { a: 5 }

    h.only.should == { a: 5 }
    h.only_pair.should == [:a, 5]
    h.only(true).should == { a: 5 }
  }

  example {
    h = { 1 => 2, 3 => 4 }

    lambda { h.only }.should raise_error(IndexError, 'not a single-element hash')
    lambda { h.only_pair }.should raise_error(IndexError, 'not a single-element hash')
    h.only(true).should == { 1 => 2 }
  }

  example {
    h = {}

    lambda { h.only }.should raise_error(IndexError, 'not a single-element hash')
    lambda { h.only_pair }.should raise_error(IndexError, 'not a single-element hash')
    h.only(true).should == {}
  }

end
