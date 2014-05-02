require 'nuggets/object/silence'

describe_extended Object, Nuggets::Object::SilenceMixin do

  before do
    @stderr, @old_stderr = '', $stderr
    $stderr = StringIO.new(@stderr)

    AConst = :foo
  end

  after do
    $stderr = @old_stderr
    Object.send(:remove_const, :AConst) if Object.const_defined?(:AConst)
  end

  example do
    AConst = :bar

    AConst.should be_equal(:bar)

    if RUBY_ENGINE == 'rbx'
      @stderr.should == ''
    else
      @stderr.should =~ /warning: already initialized constant AConst/
    end
  end

  example do
    silence { AConst = :baz }

    AConst.should be_equal(:baz)
    @stderr.should == ''
  end

end
