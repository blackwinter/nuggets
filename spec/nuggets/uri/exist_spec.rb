require 'nuggets/uri/exist'

describe URI, 'when extended by', Nuggets::URI::ExistMixin do

  it { (class << URI; ancestors; end).should include(Nuggets::URI::ExistMixin) }

  %w[
    http://www.google.de
    http://blackwinter.de
    http://blackwinter.de/index.html
  ].each { |u|
    example { URI.exist?(u).should be_true }
  }

  %w[
    htp://www.google.de
    www.google.de
    http://xuugle.de
    http://blackwinter.de/bla
    http://blackwinter.de/index.htm
  ].each { |u|
    example { URI.exist?(u).should be_false }
  }

end
