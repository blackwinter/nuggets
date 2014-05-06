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

class Array

  # call-seq:
  #   array.shuffle => new_array
  #
  # Shuffles _array_ in random order. Select a different shuffling algorithm:
  # <tt>Array.send(:alias_method, :shuffle, :shuffle_kfy)</tt>.
  def shuffle
    sort_by { ::Kernel.rand }
  end

  # call-seq:
  #   array.shuffle_knuth => new_array
  #
  # Non-destructive version of #shuffle_knuth!.
  def shuffle_knuth
    dup.shuffle_knuth!
  end

  # call-seq:
  #   array.shuffle_kfy => new_array
  #
  # Non-destructive version of #shuffle_kfy!.
  def shuffle_kfy
    dup.shuffle_kfy!
  end

  # call-seq:
  #   array.shuffle! => array
  #
  # Destructive version of #shuffle.
  def shuffle!
    replace shuffle
  end

  # call-seq:
  #   array.shuffle_knuth! => array
  #
  # Shuffles _array_ in random order using Knuth's algorithm.
  def shuffle_knuth!
    0.upto(length - 2) { |i|
      n = i + rand(length - i)
      self[i], self[n] = self[n], self[i]
    }

    self
  end

  # call-seq:
  #   array.shuffle_kfy! => array
  #
  # Shuffles _array_ in random order using the Knuth-Fisher-Yates algorithm.
  def shuffle_kfy!
    (length - 1).downto(0) { |i|
      n = rand(i + 1)
      self[n], self[i] = self[i], self[n]
    }

    self
  end

end

if $0 == __FILE__
  a = %w[1 2 3 4 5 6 7 8]
  p a

  p a.shuffle
  p a.shuffle

  p a.shuffle_knuth
  p a.shuffle_kfy

  a.shuffle!
  p a

  require 'nuggets/integer/factorial'
  require 'nuggets/enumerable/minmax'

  a = %w[a b c]
  n = 100_000
  m = a.length.f!
  e = n / m.to_f
  puts '%d / %d / %d / %.2f' % [a.length, n, m, e]

  algorithms = %w[shuffle shuffle_knuth shuffle_kfy]
  max = algorithms.max(:length)

  algorithms.each { |algorithm|
    score = ::Hash.new { |h, k| h[k] = 0 }

    n.times {
      score[a.send(algorithm)] += 1
    }

    x2 = 0
    score.sort.each { |key, value|
      x = value - e
      y = x ** 2 / e
      #puts '%s: %d (% .2f/%.2f)' % [key, value, x, y]

      x2 += y
    }
    puts "%-#{max}s = %.2f (%.2f)" % [algorithm, x2, x2 / m]
  }
end
