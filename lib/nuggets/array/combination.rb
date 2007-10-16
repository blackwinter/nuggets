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

class Array

  # call-seq:
  #   array.comb(n, ...) => new_array
  #   array.comb(n, ...) { |combination| ... } => new_array
  #
  # Returns an array of arrays of each possible +n+-combination of _array_ for each
  # given +n+. If a block is given, each +combination+ is yielded to it. Based on
  # <http://blade.nagaokaut.ac.jp/~sinara/ruby/math/combinatorics/array-comb.rb>.
  def comb(*sizes)
    # If no sizes are given, produce all!
    sizes = (0..size).to_a.reverse if sizes.empty?

    # Container for our combinations
    combinations = []

    # Collect combinations and, optionally, yield to block.
    collect_and_yield = lambda { |combination|
      combinations << combination

      yield(combination) if block_given?
    }

    sizes.each { |n|
      case n
        when 0        # Short-cut (breaks recursion)
          collect_and_yield[[]]
        when 1..size  # Ignore out-of-range values
          self[1..-1].comb(n - 1) { |combination|
            collect_and_yield[combination.unshift(first)]
          }
          self[1..-1].comb(n) { |combination|
            collect_and_yield[combination]
          }
      end
    }

    # Anyway, return what we've found...
    combinations
  end

end

if $0 == __FILE__
  a = %w[a b c d]
  p a

  p a.comb(3)
  a.comb(3) { |x|
    p x
  }

  p a.comb(4, 2, 4)

  p a.comb
  a.comb { |x|
    p x
  }
end
