class Array

  # call-seq:
  #   array.comb(n) { |x| ... } => nil
  #
  # Yield each possible +n+-combination of _array_ to block. Based on
  # <http://blade.nagaokaut.ac.jp/~sinara/ruby/math/combinatorics/array-comb.rb>.
  def comb(n = size)
    case n
      when 0
        yield []
      when (1..size)
        self[1..-1].comb(n - 1) { |x|
          yield([first] + x)
        }
        self[1..-1].comb(n) { |x|
          yield x
        }
    end
  end

  # call-seq:
  #   array.comb_all { |x| ... } => nil
  #
  # Yield each possible combination of _array_ to block.
  def comb_all
    size.downto(0) { |i|
      comb(i) { |x|
        yield x
      }
    }
  end

end

if $0 == __FILE__
  a = %w[a b c d]
  p a

  a.comb(3) { |x|
    p x
  }

  a.comb_all { |x|
    p x
  }
end
