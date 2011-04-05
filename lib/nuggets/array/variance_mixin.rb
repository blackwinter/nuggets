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

module Nuggets
  class Array
    module VarianceMixin

  # call-seq:
  #   array.variance => aFloat
  #
  # Calculates the variance[http://en.wikipedia.org/wiki/Variance] of the
  # values in _array_.
  def variance
    sx, sq = 0.0, 0.0

    return sx if empty?

    each { |x|
      x = yield x if block_given?

      sx += x
      sq += x ** 2
    }

    (sq - sx ** 2 / size) / size
  end

  alias_method :var, :variance

  # call-seq:
  #   array.covariance => aFloat
  #
  # Calculates the covariance[http://en.wikipedia.org/wiki/Covariance] of the
  # <tt>{x,y}</tt> pairs in _array_.
  def covariance
    sx, sy, sp = 0.0, 0.0, 0.0

    return sx if empty?

    each { |x, y|
      sx += x
      sy += y
      sp += x * y
    }

    (sp - sx * sy / size) / size
  end

  alias_method :cov, :covariance

    end
  end
end
