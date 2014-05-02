require 'nuggets/array/combination'

describe Array, 'combination' do

  let(:a) { %w[a b c d] }

  example {
    r = [%w[a b c], %w[a b d], %w[a c d], %w[b c d]]

    a.comb(3).should == r
    lambda { |b| a.comb(3, &b) }.should yield_successive_args(*r)
  }

  example {
    a.comb(4, 2, 4).should == [%w[a b c d], %w[a b], %w[a c], %w[a d], %w[b c], %w[b d], %w[c d], %w[a b c d]]
  }

  example {
    r = [%w[a b c d], %w[a b c], %w[a b d], %w[a c d], %w[b c d], %w[a b], %w[a c], %w[a d], %w[b c], %w[b d], %w[c d], %w[a], %w[b], %w[c], %w[d], []]

    a.comb.should == r
    lambda { |b| a.comb(&b) }.should yield_successive_args(*r)
  }

end
