require 'nuggets/hash/in_order'

describe Hash, 'in_order' do

  example {
    h = { a: 1, b: 2, c: 3 }

    h.in_order(:b, :c).should == [[:b, 2], [:c, 3], [:a, 1]]
    h.in_order(:b, :d).should == [[:b, 2], [:a, 1], [:c, 3]]
  }

end
