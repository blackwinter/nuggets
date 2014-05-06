#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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

require 'nuggets/array/mean_mixin'

module Nuggets
  class Array
    module BoostMixin

  def self.included(base)
    base.send :include, Nuggets::Array::MeanMixin
  end

  # call-seq:
  #   array.boost_factor(other_array) => aFloat
  #   array.boost_factor(other_array) { |array| ... } => aFloat
  #
  # Calculates the "boost factor" *from* the series of values in _array_ *to*
  # the series of values in +other_array+ by means of their arithmetic mean
  # or the value returned from the block given.
  #
  # Example:
  #
  #   # series of runtime measurements for old version
  #   a = [1.5, 1.6, 1.4]
  #
  #   # series of runtime measurements for new version
  #   b = [0.7, 0.8, 0.8]
  #
  #   # what speedup did we get? => almost 50%
  #   a.boost_factor(b)  #=> -0.48888888888888893
  def boost_factor(other, &block)
    block ||= :mean.to_proc
    block[other] / block[self] - 1
  end

  alias_method :boof, :boost_factor

  # call-seq:
  #   array.boost(factor) => anArray
  #
  # Maps each value in _array_ to its "boosted" value according to +factor+.
  # (Cf. #boost_factor)
  #
  # Example:
  #
  #   a.boost(a.boost_factor(b)).mean == b.mean
  def boost(factor)
    map { |x| x * (1 + factor) }
  end

    end
  end
end
