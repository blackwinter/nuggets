require 'nuggets/env/user_home'

describe_extended ENV, Nuggets::Env::UserHomeMixin, true do

  before do
    @old_env = ENV.to_hash
  end

  after do
    ENV.clear
    ENV.update(@old_env)
  end

  example do
    ENV.user_home.should be_an_instance_of(String)
  end

  example do
    ENV.clear
    ENV.user_home.should be_an_instance_of(String)
  end

  example do
    ENV['HOME'] = 'foo'
    ENV.user_home.should == 'foo'
  end

  unless RUBY_ENGINE == 'jruby'

    example do
      ENV.clear
      ENV.user_home('bar').should == 'bar'
    end

    example do
      ENV.clear
      ENV.user_home(nil).should be_nil
    end

  end

end
