require 'nuggets/array/runiq'

describe_extended Array, Nuggets::Array::RuniqMixin do

  example do
    [1, 2, 3, 4, 3, 2].runiq.should == [1, 4, 3, 2]
  end

  example do
    ary = [1, 2, 3, 4, 3, 2]
    ary.runiq!.should_not be_nil
    ary.should == [1, 4, 3, 2]
  end

  example do
    [1, 2, 3, 4].runiq.should == [1, 2, 3, 4]
  end

  example do
    ary = [1, 2, 3, 4]
    ary.runiq!.should be_nil
    ary.should == [1, 2, 3, 4]
  end

end
