require 'nuggets/string/case'

describe String, 'case' do

  example {
    s = 'Some string'

    s.case.should == :mixed
    s.should_not be_downcase
    s.should_not be_upcase
    s.should be_mixed_case
    s.should be_capitalized
  }

  example {
    s = 'some string'

    s.case.should == :lower
    s.should be_downcase
    s.should_not be_mixed_case
  }

  example {
    s = 'SOME STRING'

    s.case.should == :upper
    s.should be_upcase
    s.should_not be_mixed_case
  }

end
