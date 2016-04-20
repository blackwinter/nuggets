require 'nuggets/enumerable/minmax'

describe Enumerable, 'minmax' do

  example {
    e = %w[quux quuux quix]

    e.max.should == 'quux'
    e.max_by(:length).should == 'quuux'
    e.max(:length).should == 5 if RUBY_VERSION < '2.4'
  }

  example {
    e, b = [3, 222, 45], lambda { |i| i % 10 }

    e.max.should == 222
    e.max_by(b).should == 45
    e.max(b).should == 5 if RUBY_VERSION < '2.4'
  }

end
