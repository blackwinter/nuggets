require 'nuggets/object/silence'

describe Object, 'when extended by', Nuggets::Object::SilenceMixin do

  it { Object.ancestors.should include(Nuggets::Object::SilenceMixin) }

  context do

    before do
      @stderr, @old_stderr = '', $stderr
      $stderr = StringIO.new(@stderr)

      AConst = :foo
    end

    after do
      $stderr = @old_stderr
      Object.send(:remove_const, :AConst)
    end

    example do
      AConst = :bar

      AConst.should be_equal(:bar)
      @stderr.should =~ /warning: already initialized constant AConst/
    end

    example do
      silence { AConst = :bar }

      AConst.should be_equal(:bar)
      @stderr.should == ''
    end

  end

end
