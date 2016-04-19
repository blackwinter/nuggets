require 'nuggets/hash/deep_fetch'

describe_extended Hash, Nuggets::Hash::DeepFetchMixin do

  example do
    lambda { {}.deep_fetch('') }.should raise_error(ArgumentError, 'no keys given')
  end

  context do

    let(:hash) { { 'foo' => { 'bar' => { 'baz' => 42 }, 'bay' => 23 } } }

    example do
      hash.deep_fetch('foo/bar/baz').should == 42
    end

    example do
      hash.deep_fetch('foo/bar/bax').should == nil
    end

    example do
      lambda { hash.deep_fetch('foo/bax/baz') }.should raise_error(KeyError)
    end

    example do
      lambda { hash.deep_fetch('foo/bay/baz') }.should raise_error(TypeError)
    end

    example do
      hash.deep_fetch('foo:bar:baz').should == nil
    end

    example do
      hash.deep_fetch('foo:bar:baz', ':').should == 42
    end

    example do
      hash.deep_fetch(%w[foo bar baz]).should == 42
    end

    example do
      lambda { hash.deep_fetch([:foo, :bar, :baz]) }.should raise_error(KeyError)
    end

    example do
      (hash % 'foo/bar/baz').should == 42
    end

    example do
      (hash % %w[foo bar baz]).should == 42
    end

  end

  context do

    let(:hash) { { foo: { bar: { baz: 42 } } } }

    example do
      lambda { hash.deep_fetch('foo/bar/baz') }.should raise_error(KeyError)
    end

    example do
      hash.deep_fetch('foo/bar/baz', &:to_sym).should == 42
    end

    example do
      hash.deep_fetch('foo:bar:baz', &:to_sym).should == nil
    end

    example do
      hash.deep_fetch('foo:bar:baz', ':', &:to_sym).should == 42
    end

    example do
      lambda { hash.deep_fetch(%w[foo bar baz]) }.should raise_error(KeyError)
    end

    example do
      hash.deep_fetch([:foo, :bar, :baz]).should == 42
    end

    example do
      lambda { hash % 'foo/bar/baz' }.should raise_error(KeyError)
    end

    example do
      (hash % [:foo, :bar, :baz]).should == 42
    end

  end

  context do

    let(:hash) { { 1 => { 2 => { 3 => 42 } } } }

    example do
      lambda { hash.deep_fetch('1/2/3') }.should raise_error(KeyError)
    end

    example do
      hash.deep_fetch('1/2/3', &:to_i).should == 42
    end

    example do
      hash.deep_fetch('1:2:3', &:to_i).should == { 2 => { 3 => 42 } }
    end

    example do
      hash.deep_fetch('1:2:3', ':', &:to_i).should == 42
    end

    example do
      lambda { hash.deep_fetch(%w[1 2 3]) }.should raise_error(KeyError)
    end

    example do
      hash.deep_fetch([1, 2, 3]).should == 42
    end

    example do
      lambda { hash % '1/2/3' }.should raise_error(KeyError)
    end

    example do
      (hash % [1, 2, 3]).should == 42
    end

  end

  context do

    let(:hash) { { 'foo' => Hash.new(0) } }

    example do
      hash.deep_fetch('foo/bar').should == 0
    end

    example do
      lambda { hash.deep_fetch('foo/bar/baz') }.should raise_error(KeyError)
    end

  end

  context do

    let(:hash) { { 'foo' => Hash.new { |h, k| h[k] = [] } } }

    example do
      hash.deep_fetch('foo/bar').should == []
    end

    example do
      lambda { hash.deep_fetch('foo/bar/baz') }.should raise_error(KeyError)
    end

  end

end
