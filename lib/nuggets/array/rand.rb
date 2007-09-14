class Array

  # call-seq:
  #   array.rand => anItem
  #
  # Randomly pick an item from _array_.
  def rand
    at(Kernel.rand(size))
  end

end

if $0 == __FILE__
  a = %w[a b c d]
  p a
  p a.rand
  p a.rand
end
