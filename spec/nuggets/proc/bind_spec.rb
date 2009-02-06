require 'nuggets/proc/bind'

describe Proc, 'when extended by', Nuggets::Proc::BindMixin do

  it { Proc.ancestors.should include(Nuggets::Proc::BindMixin) }

  before :each do
    @l = lambda { bla }
  end

  example do
    lambda { @l.call }.should raise_error(NameError)
  end

  example do
    module Foo; def self.bla; 'bar'; end; end
    @l.bind(Foo).call.should == 'bar'
  end

  example do
    class Bar; def self.bla; 'baz'; end; end
    @l.bind(Bar).call.should == 'baz'
  end

  example do
    class Baz; def bla; 'foo'; end; end
    @l.bind(Baz.new).call.should == 'foo'
  end

end
