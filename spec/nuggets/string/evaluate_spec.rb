require 'nuggets/string/evaluate'

describe_extended String, Nuggets::String::EvaluateMixin do

  describe do

    %w[bl#{a}blub bl#{a}#{b}lub].each { |str|
      { 'blablub' => %w[a b], 'blubblub' => %w[ub b] }.each { |res, (a, b)|
        example { str.evaluate(binding).should == res }
      }

      example do
        lambda { str.evaluate(binding) }.should raise_error(NameError, /`a'/)
      end
    }

  end

  [ 'a"b"c', 'a\"b\"c', 'a\\"b\\"c', 'a\\\"b\\\"c',
    "a'b'c", 'a%q{b}c', 'a{b}c', 'a{bc', 'ab}c' ].each { |str|
    example { str.evaluate(binding).should == str }
  }

end
