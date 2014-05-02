require 'nuggets/uri/exist'

describe_extended URI, Nuggets::URI::ExistMixin, true do

  %w[
    http://www.google.de
    http://blackwinter.de
    http://blackwinter.de/index.html
  ].each { |u|
    example { URI.exist?(u).should == true }
  }

  %w[
    http://blackwinter.de/bla
  ].each { |u|
    example { URI.exist?(u).should == false }
  }

  %w[
    htp://www.google.de
    www.google.de
    http://xuugle.de
    http://blackwinter.de/index.htm
  ].each { |u|
    example { URI.exist?(u).should be_nil }
  }

end
