require 'nuggets/array/mean'
require 'nuggets/array/standard_deviation'

describe_extended Array, Nuggets::Array::MeanMixin do

  describe 'equalities' do

    %w[arithmetic geometric harmonic].each { |type|
      method = "#{type}_mean"

      example do
        val = rand
        ary = [val] * 10

        ary.send(method).should equal_float(val)
      end

      example do
        ary, const = Array.new(10) { rand }, rand

        res1 = ary.map { |i| const * i }.send(method)
        res2 = ary.send(method)

        res1.should equal_float(const * res2)
      end
    }

  end

  describe 'inequalities' do

    before :each do
      @ary = Array.new(10) { rand }
    end

    3.times {

      { 0 => 1, 1 => 2, 3 => 23, 0.1 => 0.2, -1 => 0, -3 => -2 }.each { |exponent1, exponent2|
        example do
          @ary.generalized_mean(exponent1).should <= @ary.generalized_mean(exponent2)
        end
      }

      example do
        res = %w[quadratic arithmetic geometric harmonic].map { |type| @ary.send("#{type}_mean") }
        res[0].should >= res[1]; res[1].should >= res[2]; res[2].should >= res[3]
      end

    }

  end

  describe 'arithmetic mean' do

    example do
      [].arithmetic_mean.should be_nil
    end

    example do
      [1].arithmetic_mean.should == 1.0
    end

    example do
      [1, 1, 1].arithmetic_mean.should == 1.0
    end

    example do
      [1, 2, 3].arithmetic_mean.should == 2.0
    end

    example do
      [3, 2, 1].arithmetic_mean.should == 2.0
    end

    example do
      [-3, -2, -1].arithmetic_mean.should == -[3, 2, 1].arithmetic_mean
    end

    example do
      [1e16, 1, 3, -1e16].arithmetic_mean.should == 1.0
    end

    xexample do
      [1e30, 1, 3, -1e30].arithmetic_mean.should == 1.0
    end

    context do

      before :each do
        @ary = [1, -2, 1, 2, 3, -4, 0, 3, 1, 2, 1, 0, 24]
        @res = @ary.arithmetic_mean
      end

      example do
        @res.should equal_float(2.46153846153846)
      end

      %w[mean average avg].each { |method|
        example { @ary.send(method).should == @res }
      }

    end

    describe '(weighted)' do

      example do
        [1, 2, 3].arithmetic_mean { |i| 0 }.should be_nil
      end

      example do
        [1, 2, 3].arithmetic_mean { |i| 1 / i.to_f }.should equal_float(1.63636363636364)
      end

      example do
        w = rand
        [1, 2, 3].arithmetic_mean { |i| w }.should == 2.0
      end

      example do
        [1, 2, 3].arithmetic_mean { |i| i ** 2 }.should equal_float(2.57142857142857)
      end

    end

  end

  # TODO: other methods
  # TODO: more examples: http://people.revoledu.com/kardi/tutorial/BasicMath/Average/mean.html

  describe 'report mean' do

    before :each do
      @ary = [[9.4, 34.75], [9.46, 34.68], [9.51, 34.61]]

      @ary1 = @ary.map(&:first)
      @ary2 = @ary.map(&:last)
    end

    describe 'w/o stddev' do

      before :each do
        [@ary, @ary1, @ary2].each { |ary|
          class << ary; undef_method :std; end if ary.respond_to?(:std)
        }
      end

      example do
        @ary.report_mean.should == ['9.4567', '34.6800']
      end

      example do
        @ary.report_mean(:harmonic).should == ['9.4565', '34.6799']
      end

      example do
        @ary.unshift(%w[a b]).report_mean(nil, 2).should == ['a  9.46', 'b  34.68']
      end

      example do
        @ary1.report_mean.should == ['9.4567']
      end

      example do
        @ary2.report_mean.should == ['34.6800']
      end

      example do
        [].report_mean.should be_nil
      end

    end

    describe 'w/ stddev' do

      example do
        @ary.report_mean.should == ['9.4567 +/- 0.0450', '34.6800 +/- 0.0572']
      end

      example do
        @ary.report_mean(:harmonic).should == ['9.4565 +/- 0.0450', '34.6799 +/- 0.0572']
      end

      example do
        @ary.unshift(%w[a b]).report_mean(nil, 2).should == ['a  9.46 +/- 0.04', 'b  34.68 +/- 0.06']
      end

      example do
        @ary1.report_mean.should == ['9.4567 +/- 0.0450']
      end

      example do
        @ary2.report_mean.should == ['34.6800 +/- 0.0572']
      end

      example do
        [].report_mean.should be_nil
      end

    end

  end

end
