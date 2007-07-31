class Hash

  # call-seq:
  #   hash.insert(key, value) => new_hash
  #   hash.insert(key, value) { |old_value, value| ... } => new_hash
  #
  # Inserts +value+ into _hash_ at +key+, while merging existing values at
  # +key+ instead of just overwriting. Uses default Hash#merge or block for
  # merging.
  def insert(key, value, &block)
    dup.insert!(key, value, &block)
  end

  # call-seq:
  #   hash.insert!(key, value) => hash
  #   hash.insert!(key, value) { |old_value, value| ... } => hash
  #
  # Destructive version of #insert.
  def insert!(key, value, &block)
    block ||= lambda { |old_val, val| old_val.merge(val) }

    self[key] = begin
      block[self[key], value]
    rescue NoMethodError, TypeError
      value
    end

    self
  end

end

if $0 == __FILE__
  h = { :a => 0, :b => { :b1 => 1, :b2 => 2 } }
  p h

  p h.insert(:a, -1)
  p h.insert(:b, :b3 => 3)

  h.insert!(:b, :b0 => 0)
  p h
end
