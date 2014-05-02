require 'nuggets/string/capitalize_first'

describe String, 'capitalize_first' do

  {
    'Some string' => 'Some string',
    'some string' => 'Some string',
    'SOME STRING' => 'SOME STRING'
  }.each { |s, c|
    example { s.capitalize_first.should == c }
  }

end
