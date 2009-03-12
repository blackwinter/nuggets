require 'nuggets/env/set'

describe ENV, 'when extended by', Nuggets::Env::SetMixin do

  it { class << ENV; ancestors; end.should include(Nuggets::Env::SetMixin) }

  before do
    @original = ENV.to_hash
  end

  example do
    ENV.with(:lang => 'C') { ENV['LANG'].should == 'C' }
    ENV['LANG'].should == @original['LANG']
  end

  example do
    ENV.set(:lang => 'C').to_hash.should == @original
    ENV.to_hash.should == { 'LANG' => 'C' }
  end

  example do
    ENV.set(@original)
    ENV.to_hash.should == @original
  end

end
