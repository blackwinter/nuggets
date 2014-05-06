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

module Nuggets
  class Array
    module RegressionMixin

  # call-seq:
  #   array.linear_least_squares => anArray
  #
  # Calculates the {linear least squares regression}[http://en.wikipedia.org/wiki/Simple_linear_regression]
  # for the <tt>{x,y}</tt> pairs in _array_. If _array_ only contains
  # values instead of pairs, +y+ will be the value and +x+ will be each
  # value's position (rank) in _array_.
  def linear_least_squares
    return [] if empty?

    sx, sy, sq, sp, xys = 0.0, 0.0, 0.0, 0.0, first.respond_to?(:to_ary) ?
      self : self.class.new(size) { |i| [i + 1, at(i)] }

    xys.each { |x, y| sx += x; sy += y; sq += x ** 2; sp += x * y }

    b = (v = sq * size - sx ** 2) == 0 ? 0 : (sp * size - sx * sy) / v
    a = (sy - b * sx) / size

    xys.map { |x, _| [x, a + b * x] }
  end

  alias_method :llsq, :linear_least_squares

  # call-seq:
  #   array.linear_least_squares_incremental => anIncrementalLinearRegression
  #
  # Returns an instance of IncrementalLinearRegression for _array_; _array_
  # being a list of values (in contrast to #linear_least_squares, which also
  # accepts <tt>{x,y}</tt> pairs). Use IncrementalLinearRegression directly,
  # or apply this method to an empty _array_, for more control over its input
  # data.
  def linear_least_squares_incremental
    IncrementalLinearRegression.new(*self)
  end

  alias_method :llsqi, :linear_least_squares_incremental

  # Inspired by {Incremental Simple Linear Regression in Ruby}[http://blog.codewren.ch/post/31378435699].
  #
  # Use #push to add a single <tt>{x,y}</tt> pair, #add to add a list of +y+
  # values, and #<< to add a single +y+ value. Whenever a single +y+ value is
  # added, it's associated with an +x+ value of its position (rank) in the
  # data series.
  #
  # Call #to_a (or any Enumerable method) to work with the regression points.
  class IncrementalLinearRegression

    include ::Enumerable

    def initialize(*ys)
      clear
      add(*ys)
    end

    def clear
      @x = @y = @xx = @xy = 0.0
      @cnt, @slope = 0, nil
      self
    end

    def push(x, y)
      cnt, @slope = @cnt += 1, nil

      @x  += (x     - @x)  / cnt
      @y  += (y     - @y)  / cnt
      @xx += (x * x - @xx) / cnt
      @xy += (x * y - @xy) / cnt

      self
    end

    def add(*ys)
      ys.each { |y| self << y }
      self
    end

    def <<(y)
      push(@cnt + 1, y)
    end

    def slope
      @slope ||= @cnt < 2 ? 0 : (@xy - @x * @y) / (@xx - @x * @x)
    end

    def intercept
      at(0)
    end

    def at(x)
      @y + slope * (x - @x)
    end

    alias_method :[], :at

    def each
      @cnt.times { |i| yield [x = i + 1, at(x)] }
      self
    end

    def to_a(range = nil)
      range ? range.map { |x| [x, at(x)] } : super()
    end

    def to_s
      s, i = slope, intercept

      y = s == 0 ? i : begin
        x = s.abs == 1 ? "#{'-' if s < 0}x" : "#{s} * x"
        i == 0 ? x : "#{x} #{i < 0 ? '-' : '+'} #{i.abs}"
      end

      "y := #{y}".gsub(/\.0\b/, '')
    end

  end

    end
  end
end
