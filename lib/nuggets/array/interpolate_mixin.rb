#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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
    module InterpolateMixin

  # call-seq:
  #   array.interpolate([x0[, xN]]) => anArray
  #
  # Simple {linear interpolation}[http://en.wikipedia.org/wiki/Linear_interpolation]
  # of missing values in _array_.
  #
  # Example:
  #
  #   [1, nil, 3, nil, 5].interpolate #=> [1, 2, 3, 4, 5]
  def interpolate(x0 = 0, xN = x0)
    res, xX, interpolate = dup, [], lambda { |x|
      m = (x - x0) / xX.size.succ.to_f unless xX.empty?
      xX.each_with_index { |j, k| res[j] = m * k.succ + x0 }.clear
      x
    }

    each_with_index { |x, i| x ? x0 = interpolate[x] : xX << i }
    interpolate[xN] if xN
    res
  end

    end
  end
end
