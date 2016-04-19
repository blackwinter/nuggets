require 'nuggets/hash/deep_merge'

describe_extended Hash, Nuggets::Hash::DeepMergeMixin do

  example do
    { a: 1 }.deep_merge(a: 2).should == { a: 2 }
  end

  example do
    { a: 1 }.deep_merge(b: 2).should == { a: 1, b: 2 }
  end

  example do
    { a: { b: 1 } }.deep_merge(b: 2).should == { a: { b: 1 }, b: 2 }
  end

  example do
    { a: { b: 1 } }.deep_merge(a: { b: 2 }).should == { a: { b: 2 } }
  end

  example do
    lambda { { a: { b: { c: 1 } } }.deep_merge(a: { b: 2 }) }.should raise_error(TypeError)
  end

  example do
    { a: { b: { c: 1 } } }.deep_merge(a: { b: { c: 2 } }).should == { a: { b: { c: 2 } } }
  end

  example do
    { a: { b: { c: 1 } } }.deep_merge(a: { b: { d: 2 } }).should == { a: { b: { c: 1, d: 2 } } }
  end

  example do
    { a: { b: { c: 1 } } }.deep_merge(a: { b: { c: 2 }, d: 3 }).should == { a: { b: { c: 2 }, d: 3 } }
  end

  example do
    { a: { b: { c: 1 }, d: 2 } }.deep_merge(a: { b: { c: 2 }, d: 3 }).should == { a: { b: { c: 2 }, d: 3 } }
  end

  example do
    { a: { b: { c: 1 }, d: 2 }, e: 3 }.deep_merge(a: { b: { c: 2 }, d: 3 }).should == { a: { b: { c: 2 }, d: 3 }, e: 3 }
  end

  example do
    { a: { b: { c: 1 } }, d: { e: 3 } }.deep_merge(a: { b: { c: 2 } }, d: { e: 4 }).should == { a: { b: { c: 2 } }, d: { e: 4 } }
  end

  context do

    before :each do
      @sub_hash1 = { b: 1 }
      @sub_hash2 = { b: 2 }

      @hash1 = { a: @sub_hash1 }
      @hash2 = { a: @sub_hash2 }
      @hash3 = { a: { b: 2} }
    end

    example do
      @hash1.deep_merge(@hash2).should == @hash3
      @hash1.should_not == @hash3

      @sub_hash1[:b].should == 1
      @sub_hash2[:b].should == 2
    end

    example do
      @hash1.deep_merge!(@hash2).should == @hash3
      @hash1.should == @hash3

      @sub_hash1[:b].should == 1
      @sub_hash2[:b].should == 2
    end

  end

end
