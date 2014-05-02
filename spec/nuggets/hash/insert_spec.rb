require 'nuggets/hash/insert'

describe Hash, 'insert' do

  let(:h) { { a: 0, b: { b1: 1, b2: 2 } } }

  example { h.insert(a: -1).should == { a: -1, b: { b1: 1, b2: 2 } } }

  example { h.insert(b: { b3: 3 }).should == { a: 0, b: { b1: 1, b2: 2, b3: 3 } } }

  example { h.insert!(b: { b0: 0 }); h.should == { a: 0, b: { b1: 1, b2: 2, b0: 0 } } }

end
