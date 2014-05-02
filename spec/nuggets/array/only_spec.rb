require 'nuggets/array/only'

describe Array, 'only' do

  example {
    a = [5]

    a.only.should == 5
    a.only(true).should == 5
  }

  example {
    a = [1, 2, 3]

    lambda { a.only }.should raise_error(IndexError, 'not a single-element array')
    a.only(true).should == 1
  }

  example {
    a = []

    lambda { a.only }.should raise_error(IndexError, 'not a single-element array')
    a.only(true).should be_nil
  }

end
