#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
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

require 'nuggets/array/correlation_mixin'

module Nuggets
  class Array
    module RegressionMixin

  def self.included(base)
    base.send :include, Nuggets::Array::CorrelationMixin
  end

  # call-seq:
  #   array.linear_least_squares => anArray
  #
  # Calculates the {linear least squares regression}[http://en.wikipedia.org/wiki/Ordinary_least_squares]
  # for the <tt>{x,y}</tt> pairs in _array_.
  def linear_least_squares
    sx, sy = 0.0, 0.0

    return [] if empty?

    each { |x, y|
      sx += x
      sy += y
    }

    b = corr * sy / sx
    a = (sy - b * sx) / size.to_f

    map { |x, _| [x, a + b * x] }
  end

  alias_method :llsq, :linear_least_squares

    end
  end
end
