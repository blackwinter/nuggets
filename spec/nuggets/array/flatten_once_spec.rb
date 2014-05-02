require 'nuggets/array/flatten_once'

describe Array, 'flatten_once' do

  let(:a) { [1, 2, [3, 4, 5], 6, [7, [8, 9]]] }

  example {
    a.flatten_once.should == [1, 2, 3, 4, 5, 6, 7, [8, 9]]
  }

  example {
    a.flatten_once!
    a.should == [1, 2, 3, 4, 5, 6, 7, [8, 9]]
  }

end
