#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2008 Jens Wille                                          #
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
  def nsub(*args)
    _dup = dup
    (block_given? ?
      _dup.nsub!(*args) { |*a| yield(*a) } :
      _dup.nsub!(*args)) || _dup
  end

  # call-seq:
  #   str.nsub!(pattern, replacement, count) => str or nil
  #   str.nsub!(pattern, count) { |match| ... } => str or nil
  #
  # Performs the substitutions of #nsub in place, returning _str_, or +nil+ if
  # no substitutions were performed.
  def nsub!(*args)
    pattern, i = args.first, 0

    case args.size
      when 2
        # Only +count+ given
        count = args.last

        gsub!(pattern) { |match| (i += 1) <= count ? yield(match) : match }
      when 3
        # Both +replacement+ and +count+ given;
        # ignore block (just like String#gsub does)
        replacement, count = args.values_at(1, 2)

        gsub!(pattern) { |match| (i += 1) <= count ? replacement : match }
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 2-3)"
    end
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
