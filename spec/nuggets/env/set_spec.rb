require 'nuggets/env/set'

describe_extended ENV, Nuggets::Env::SetMixin, true do

  before do
    @original = ENV.to_hash
  end

  after do
    ENV.clear
    ENV.update(@original)
  end

  example do
    ENV.with(lang: 'C') { ENV['LANG'].should == 'C' }
    ENV['LANG'].should == @original['LANG']
  end

  example do
    ENV.set(lang: 'C').to_hash.should == @original
    ENV.to_hash.should == { 'LANG' => 'C' }
  end

  example do
    ENV.set(@original)
    ENV.to_hash.should == @original
  end

end
