require 'nuggets/object/singleton_class'

describe_extended Object, Nuggets::Object::SingletonClassMixin do

  objects = [Class, Object.new, Class.new, 's', [1, 2], { a: 'b' }]
  objects.unshift(Object) unless %w[jruby rbx].include?(RUBY_ENGINE)

  objects.each { |o|
    example { o.should_not be_a_singleton_class }
    example(nil, if: o != Object || RUBY_VERSION < '2.3') {
      lambda { o.singleton_object }.should raise_error(TypeError) }

    s = o.singleton_class

    example { s.should be_a_singleton_class }
    example { s.singleton_object.should be_equal(o) }
  }

  example do
    c = Class.new
    c.should_not be_a_singleton_class
    o = c.new
    c.should_not be_a_singleton_class
  end

  example do
    nil.singleton_class.should == NilClass

    if RUBY_VERSION < '2'
      NilClass.should be_a_singleton_class
    else
      NilClass.should be_a_virtual_class
    end

    NilClass.singleton_object.should be_equal(nil)
  end

  example do
    class A; end
    class B < A; end

    a = A.singleton_class
    b = B.singleton_class

    a.should be_a_singleton_class
    b.should be_a_singleton_class

    a.singleton_object.should be_equal(A)
    b.singleton_object.should be_equal(B)
  end

end
