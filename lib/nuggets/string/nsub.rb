class String

  # call-seq:
  #   str.nsub(pattern, replacement, count) => new_str
  #   str.nsub(pattern, count) { |match| ... } => new_str
  #
  # Returns a copy of _str_ with the _first_ +count+ occurrences of pattern
  # replaced with either +replacement+ or the value of the block.
  def nsub(*args, &block)
    dup.nsub!(*args, &block)
  end

  # call-seq:
  #   str.nsub!(pattern, replacement, count) => str or nil
  #   str.nsub!(pattern, count) { |match| ... } => str or nil
  #
  # Performs the substitutions of #nsub in place, returning _str_, or +nil+ if
  # no substitutions were performed.
  def nsub!(*args, &block)
    case args.size
      when 2
        pattern = args.shift

        # Only +count+ given; require block
        count = *args
        raise(ArgumentError, 'no block given') unless block_given?
      when 3
        pattern = args.shift

        # Both +replacement+ and +count+ given;
        # ignore block (just like String#gsub does)
        replacement, count = *args
        block = lambda { replacement }
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 2-3)"
    end
    
    i = 0
    gsub!(pattern) { |match|
      (i += 1) <= count ? block[match] : match
    }
  end

end

if $0 == __FILE__
  s = 'a b c d e f g h i'
  puts s

  puts s.nsub(' ', '', 6)
  puts s.nsub(' ', 6) { '' }

  s.nsub!(' ', '', 6)
  puts s
end
