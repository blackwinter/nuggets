require 'nuggets/env/user_encoding'

describe ENV, 'when extended by', Nuggets::Env::UserEncodingMixin do

  it { class << ENV; ancestors; end.should include(Nuggets::Env::UserEncodingMixin) }

  before do
    @old_env = ENV.to_hash
  end

  after do
    ENV.clear
    ENV.update(@old_env)
  end

  example do
    ENV.user_encoding.should be_an_instance_of(String)
  end

  example do
    ENV.clear
    ENV.user_encoding.should be_an_instance_of(String)
  end

  example do
    ENV['ENCODING'] = 'foo'
    ENV.user_encoding.should == 'foo'
  end

  example do
    ENV.clear
    ENV.user_encoding('bar').should == 'bar'
  end

  example do
    ENV.clear
    ENV.user_encoding(nil).should be_nil
  end

end
