#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# nuggets is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# nuggets is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with nuggets. If not, see <http://www.gnu.org/licenses/>.             #
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

    combinations, collect_and_yield = [], lambda { |combination|
      yield combination if block_given?
      combinations << combination
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

    combinations
  end

end
