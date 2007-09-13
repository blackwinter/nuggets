require File.join(File.dirname(__FILE__), 'flatten_once')

class Array

  # call-seq:
  #   array.to_h => aHash
  #   array.to_h(value) => aHash
  #
  # If no +value+ is given, converts _array_, being an array of two-element
  # arrays, into a hash, preserving sub-arrays. Otherwise, maps each element
  # of _array_ to +value+.
  def to_hash(value = default = Object.new)
    if value == default
      Hash[*flatten_once]
    else
      inject({}) { |hash, element|
        hash.update(element => value)
      }
    end
  end
  alias_method :to_h, :to_hash

end

if $0 == __FILE__
  a = [[:a, 1], [:b, 2], [:c, 3]]
  p a
  p a.to_h

  b = [[:a, [1, 2]], [:b, 3], [[:c, :d], [4, [5, 6]]]]
  p b
  p b.to_h

  c = %w[a b c d]
  p c
  p c.to_h(1)
end
