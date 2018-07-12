require 'nuggets/env/user_home'

describe_extended ENV, Nuggets::Env::UserHomeMixin, true do

  before do
    @old_env = ENV.to_hash
  end

  after do
    ENV.clear.update(@old_env)
  end

  example do
    ENV.user_home.should be_an_instance_of(String)
  end

  example do
    ENV['HOME'] = 'foo'
    ENV.user_home.should == 'foo'
  end

end
