require File.join(File.dirname(__FILE__), 'flatten_once')

class Array

  # call-seq:
  #   array.to_h => aHash
  #
  # Converts _array_, being an array of two-element arrays, into a hash,
  # preserving sub-arrays.
  def to_hash
    Hash[*flatten_once]
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
end
