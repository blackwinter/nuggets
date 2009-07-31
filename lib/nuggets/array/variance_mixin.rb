#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2009 Jens Wille                                          #
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

module Nuggets
  class Array
    module VarianceMixin

  # call-seq:
  #   array.variance => aFloat
  #
  # Calculates the variance of the items in _array_.
  #
  # Based on <http://warrenseen.com/blog/2006/03/13/how-to-calculate-standard-deviation/>.
  def variance
    s, mean = 0.0, 0.0

    return s if empty?

    each_with_index { |x, n|
      x = yield x if block_given?

      delta = x - mean
      mean += delta / (n + 1)
      s += delta * (x - mean)
    }

    s / size
  end

  alias_method :var, :variance

    end
  end
end
