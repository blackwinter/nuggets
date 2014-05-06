#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2013 Jens Wille                                          #
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

    (total / weights.to_f) ** (1.0 / exponent) unless weights.zero?
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

  # call-seq:
  #   array.report_mean => anArray
  #   array.report_mean(method[, precision]) => anArray
  #
  # Expects _array_ to be an array of arrays ("rows") of numeric values;
  # the first "row" may consist of strings (labels) instead. Returns an
  # array of strings with the mean (according to +method+, default #mean)
  # of each "column", prepended with the label, if present, and appended
  # with the standard deviation, if available; all values are subject to
  # +precision+.
  #
  # If _array_ is a flat array of numeric values, it is treated as a single
  # "column".
  #
  # Returns +nil+ if _array_ is empty.
  #
  # Examples (with standard deviation):
  #
  #   [[9.4, 34.75], [9.46, 34.68], [9.51, 34.61]].report_mean
  #   #=> ["9.4567 +/- 0.0450", "34.6800 +/- 0.0572"]
  #
  #   [[9.4, 34.75], [9.46, 34.68], [9.51, 34.61]].report_mean(:harmonic)
  #   #=> ["9.4565 +/- 0.0450", "34.6799 +/- 0.0572"]
  #
  #   [["a", "b"], [9.4, 34.75], [9.46, 34.68], [9.51, 34.61]].report_mean(nil, 2)
  #   #=> ["a  9.46 +/- 0.04", "b  34.68 +/- 0.06"]
  #
  #   CSV.read('csv', headers: true, converters: :numeric).to_a.report_mean
  #   #=> ["a    9.4567 +/- 0.0450", "b    34.6800 +/- 0.0572"]
  #
  #   [9.4, 9.46, 9.51].report_mean
  #   #=> ["9.4567 +/- 0.0450"]
  #
  #   [34.75, 34.68, 34.61].report_mean
  #   #=> ["34.6800 +/- 0.0572"]
  #
  #   [].report_mean
  #   #=> nil
  def report_mean(method = nil, precision = 4)
    return if empty?

    return clone.replace(self.class.new.push(self).transpose).
      report_mean(method, precision) unless first.is_a?(self.class)

    met, sep = [method ||= :mean, 'mean'], ['', '_']
    lab, std = first.first.is_a?(::String), respond_to?(:std)

    fmt = ["%-#{precision}s", "%.#{precision}f", "+/- %.#{precision}f"]

    until respond_to?(method) || sep.empty?
      method = met.join(sep.shift)
    end

    transpose.map! { |x|
      i, a = [], []

      i << 0 and a << x.shift if lab
      i << 1 and a << x.send(method)
      i << 2 and a << x.std if std

      fmt.values_at(*i).join(' ') % a
    }
  end

    end
  end
end
