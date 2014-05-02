require 'nuggets/array/limit'
require 'nuggets/numeric/limit'

describe_extended Array, Nuggets::Array::LimitMixin do

  describe '#limit' do

    example do
      [].limit(0, 1).should == []
    end

    example do
      [1].limit(0, 1).should == [1]
    end

    example do
      [1, 1, 1].limit(0, 1).should == [1]
    end

    example do
      [1, 2, 3].limit(0, 1).should == [1]
    end

    example do
      [1, 2, 3].limit(0, 2).should == [1, 2]
    end

    example do
      [-3, -2, -1].limit(0, 1).should == [0]
    end

    example do
      [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].limit(-2, 2).should == [1, -2, 2, 0]
    end

  end

  describe '#cap' do

    example do
      [1, 1, 1].cap(1).should == [1, 1, 1]
    end

    example do
      [1, 2, 3].cap(1).should == [1, 1, 1]
    end

    example do
      [1, 2, 3].cap(2).should == [1, 2, 2]
    end

    example do
      [-3, -2, -1].cap(0).should == [-3, -2, -1]
    end

    example do
      [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24].cap(-2..2).should == [1, -2, 1, 2, 2, -2, 0, 2, 1, 2, 1, 0, 2]
    end

  end

end
