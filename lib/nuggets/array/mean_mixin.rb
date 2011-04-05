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
    module MeanMixin

  # call-seq:
  #   array.generalized_mean(exponent) => aFloat
  #   array.generalized_mean(exponent) { |x| ... } => aFloat
  #
  # Calculates the {generalized mean}[http://en.wikipedia.org/wiki/Generalized_mean]
  # of the values in _array_ for +exponent+. Returns the #geometric_mean if
  # +exponent+ is zero.
  #
  # An optional block may be passed to provide a weight for each value.
  # Defaults to 1. Returns +nil+ if the sum of all weights is zero (this
  # includes _array_ being empty).
  def generalized_mean(exponent, &block)
    return geometric_mean(&block) if exponent.zero?

    total, weights = 0, 0

    each { |x|
      weight = block ? block[x] : 1

      total   += weight * x ** exponent
      weights += weight
    }

    (total / weights.to_f) ** (1 / exponent) unless weights.zero?
  end

  alias_method :power_mean,     :generalized_mean
  alias_method :minkowski_mean, :generalized_mean

  # call-seq:
  #   array.arithmetic_mean => aFloat
  #   array.arithmetic_mean { |x| ... } => aFloat
  #
  # Calculates the {arithmetic mean}[http://en.wikipedia.org/wiki/Arithmetic_mean]
  # of the values in _array_.
  #
  # An optional block may be passed to provide a weight for each value.
  # Defaults to 1. Returns +nil+ if the sum of all weights is zero (this
  # includes _array_ being empty).
  def arithmetic_mean(&block)
    generalized_mean(1, &block)
  end

  alias_method :mean,    :arithmetic_mean
  alias_method :average, :arithmetic_mean
  alias_method :avg,     :arithmetic_mean

  # call-seq:
  #   array.root_mean_square => aFloat
  #   array.root_mean_square { |x| ... } => aFloat
  #
  # Calculates the {root mean square}[http://en.wikipedia.org/wiki/Root_mean_square]
  # (quadratic mean) of the values in _array_.
  #
  # An optional block may be passed to provide a weight for each value.
  # Defaults to 1. Returns +nil+ if the sum of all weights is zero (this
  # includes _array_ being empty).
  def root_mean_square(&block)
    generalized_mean(2, &block)
  end

  alias_method :rms,            :root_mean_square
  alias_method :quadratic_mean, :root_mean_square

  # call-seq:
  #   array.harmonic_mean => aFloat
  #   array.harmonic_mean { |x| ... } => aFloat
  #
  # Calculates the {harmonic mean}[http://en.wikipedia.org/wiki/Harmonic_mean]
  # of the values in _array_.
  #
  # An optional block may be passed to provide a weight for each value.
  # Defaults to 1. Returns +nil+ if the sum of all weights is zero (this
  # includes _array_ being empty).
  def harmonic_mean(&block)
    generalized_mean(-1, &block)
  end

  alias_method :harmean, :harmonic_mean

  # call-seq:
  #   array.geometric_mean => aFloat
  #   array.geometric_mean { |x| ... } => aFloat
  #
  # Calculates the {geometric mean}[http://en.wikipedia.org/wiki/Geometric_median]
  # of the values in _array_.
  #
  # An optional block may be passed to provide a weight for each value.
  # Defaults to 1. Returns +nil+ if the sum of all weights is zero (this
  # includes _array_ being empty).
  def geometric_mean
    total, weights = 1, 0

    each { |x|
      weight = block_given? ? yield(x) : 1

      total   *= x ** weight
      weights += weight
    }

    total ** (1 / weights.to_f) unless weights.zero?
  end

  alias_method :geomean, :geometric_mean

    end
  end
end
