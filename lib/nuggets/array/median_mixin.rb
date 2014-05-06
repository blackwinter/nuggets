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

module Nuggets
  class Array
    module MedianMixin

  # call-seq:
  #   array.median([prefer]) => anObject
  #   array.median { |left, right| ... } => anObject
  #
  # Determines the median[http://en.wikipedia.org/wiki/Median] of the values
  # in _array_. _array_ must be sortable.
  #
  # If _array_ contains an even number of values, a block may be passed to
  # decide what the "middle" (average) should be. For Numeric values, the
  # block is optional and the arithmetic mean will be used when no block
  # is passed; for other values, the block is mandatory.
  #
  # Alternatively, +prefer+ may either be set to +true+, 1, or <tt>:left</tt>
  # to use the left "middle", or to +false+, 2, or <tt>:right</tt> to use the
  # right "middle". The block will then be ignored.
  def median(prefer = nil)
    return if empty?

    sorted, index = sort, (size / 2.0).ceil - 1

    case prefer
      when true,  1, :left  then prefer_left  = true
      when false, 2, :right then prefer_right = true
    end

    middle1 = sorted[index]
    return middle1 if prefer_left || size.odd?

    middle2 = sorted[index + 1]
    return middle2 if prefer_right

    unless block_given?
      # simple arithmetic mean
      (middle1 + middle2) / 2.0
    else
      # make your own average
      yield middle1, middle2
    end
  end

    end
  end
end
