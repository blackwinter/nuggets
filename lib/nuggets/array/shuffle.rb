class Array

  # call-seq:
  #   array.shuffle => new_array
  #
  # Shuffles _array_ in random order.
  def shuffle
    sort_by { Kernel.rand }
  end

  # call-seq:
  #   array.shuffle! => array
  #
  # Destructive version of #shuffle.
  def shuffle!
    replace shuffle
  end

end

if $0 == __FILE__
  a = %w[1 2 3 4 5 6 7 8]
  p a

  p a.shuffle
  p a.shuffle

  a.shuffle!
  p a
end
