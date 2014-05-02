require 'nuggets/string/xor'

describe_extended String, Nuggets::String::XorMixin do

  describe 'same length' do

    before do
      @str1 = 'foobar'
      @str2 = 'secret'

      @res = "\025\n\f\020\004\006"
    end

    example { @str1.xor(@str2).should == @res }

    example { @str2.xor(@str1).should == @res }

    example { (@str1 ^ @str2).should == @res }

    example { (@str2 ^ @str1).should == @res }

  end

  describe 'different length' do

    before do
      @str1 = 'baz'
      @str2 = 'secret'
      @str3 = 'foobarbaz'

      @res1 = "sec\020\004\016"
      @res2 = "foo\021\004\021\020\004\016"
    end

    example { @str1.xor(@str2).should == @res1 }

    example { @str2.xor(@str1).should == @res1 }

    example { (@str1 ^ @str2).should == @res1 }

    example { (@str2 ^ @str1).should == @res1 }

    example { lambda { @str1.xor(@str2, true) }.should raise_error(ArgumentError, 'must be of same length') }

    example { @str2.xor(@str3).should == @res2 }

    example { @str3.xor(@str2).should == @res2 }

    example { (@str2 ^ @str3).should == @res2 }

    example { (@str3 ^ @str2).should == @res2 }

    example { lambda { @str2.xor(@str3, true) }.should raise_error(ArgumentError, 'must be of same length') }

  end

end
