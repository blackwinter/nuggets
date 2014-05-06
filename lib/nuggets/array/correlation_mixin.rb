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

require 'nuggets/array/standard_deviation_mixin'

module Nuggets
  class Array
    module CorrelationMixin

  def self.included(base)
    base.send :include, Nuggets::Array::StandardDeviationMixin
  end

  # call-seq:
  #   array.correlation_coefficient => anArray
  #
  # Calculates the {Pearson product-moment correlation
  # coefficient}[http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient]
  # for the <tt>{x,y}</tt> pairs in _array_. If _array_ only contains
  # values instead of pairs, +y+ will be the value and +x+ will be each
  # value's position (rank) in _array_.
  def correlation_coefficient
    return 0.0 if empty?

    target = first.respond_to?(:to_ary) ? self :
      self.class.new(size) { |i| [i + 1, at(i)] }

    c = target.cov

    (sx = target.std { |x, _| x }).zero? ||
    (sy = target.std { |_, y| y }).zero? ?
      c < 0 ? -1.0 : 1.0 : c / (sx * sy)
  end

  alias_method :corr, :correlation_coefficient
  alias_method :pmcc, :correlation_coefficient

    end
  end
end
