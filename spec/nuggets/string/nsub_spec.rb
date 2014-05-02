require 'nuggets/string/nsub'

describe String, 'nsub' do

  let(:s) { 'a b c d e f g h i' }

  example { s.nsub(' ', '', 6).should == 'abcdefg h i' }

  example { s.nsub(' ', 6) { '' }.should == 'abcdefg h i' }

  example { s.nsub!(' ', '', 6); s.should == 'abcdefg h i' }

end
