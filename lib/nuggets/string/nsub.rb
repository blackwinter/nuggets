#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# ruby-nuggets is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for    #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.              #
#                                                                             #
###############################################################################
#++

class String

  # call-seq:
  #   str.nsub(pattern, replacement, count) => new_str
  #   str.nsub(pattern, count) { |match| ... } => new_str
  #
  # Returns a copy of _str_ with the _first_ +count+ occurrences of pattern
  # replaced with either +replacement+ or the value of the block.
  def nsub(*args, &block)
    dup.nsub!(*args, &block) || dup
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
