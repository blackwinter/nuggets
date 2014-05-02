require 'nuggets/string/sub_with_md'

describe String, 'sub_with_md' do

  let(:s) { 'Foo, Bar - Baz' }

  example {
    s.gsub(/\w(\w+)(\W*)/) { |m|
      "#{$1.gsub(/[ao]/, 'X')}#{$2}"
    }.should == 'XXXrXz'
  }

  example {
    s.gsub_with_md(/\w(\w+)(\W*)/) { |md|
      "#{md[1].gsub(/[ao]/, 'X')}#{md[2]}"
    }.should == 'XX, Xr - Xz'
  }

  example {
    s.gsub_with_md(/\w(\w+)(\W*)/) { |md|
      "#{md[1].gsub_with_md(/[ao]/) { |md2| md2[0].upcase }}#{md[2]}"
    }.should == 'OO, Ar - Az'
  }

end
