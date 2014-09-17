require 'nuggets/module/query_attr'

describe_extended Module, Nuggets::Module::QueryAttrMixin do

  shared_examples 'common' do

    subject { described_class.new }

    example {
      expect(subject.foo?).to be_nil
    }

    example {
      subject.instance_variable_set(:@foo, 42)
      expect(subject.foo?).to equal(true)
    }

    example {
      expect { subject.foo }.to raise_error(NoMethodError)
    }

  end

  shared_examples 'reader' do

    it_behaves_like 'common'

    example {
      expect { subject.foo = 42 }.to raise_error(NoMethodError)
    }

  end

  describe(Class.new { query_attr :foo }, '#query_attr') do
    it_behaves_like 'reader'
  end

  describe(Class.new { query_reader :foo }, '#query_reader') do
    it_behaves_like 'reader'
  end

  describe(Class.new { query_accessor :foo }, '#query_accessor') do

    it_behaves_like 'common'

    example {
      subject.foo = 42
      expect(subject.foo?).to equal(true)
    }

    example {
      subject.foo = nil
      expect(subject.foo?).to equal(false)
    }

  end

end
