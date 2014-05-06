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
  # Calculates the covariance[http://en.wikipedia.org/wiki/Covariance] of
  # the <tt>{x,y}</tt> pairs in _array_. If _array_ only contains values
  # instead of pairs, +y+ will be the value and +x+ will be each value's
  # position (rank) in _array_.
  def covariance
    sx, sy, sp = 0.0, 0.0, 0.0

    return sx if empty?

    target = first.respond_to?(:to_ary) ? self :
      self.class.new(size) { |i| [i + 1, at(i)] }

    target.each { |x, y|
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
