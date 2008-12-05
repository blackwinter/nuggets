#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2008 Jens Wille                                          #
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

class Integer

  # Memoization container: integer => factorial(integer)
  FACTORIAL = { 0 => 1 }

  # call-seq:
  #   int.factorial => anInteger
  #
  # Calculate the factorial of _int_. To use the memoized version:
  # <tt>Integer.send(:alias_method, :factorial, :factorial_memoized)</tt>
  def factorial
    (1..self).inject { |f, i| f * i }
  end

  # call-seq:
  #   int.factorial_memoized => anInteger
  #
  # Calculate the factorial of _int_ with the help of memoization (Which gives
  # a considerable speedup for repeated calculations -- at the cost of memory).
  #
  # WARNING: Don't try to calculate the factorial this way for "large"
  # integers! This might well bring your system down to its knees... ;-)
  def factorial_memoized
    FACTORIAL[self] ||= (1..self).inject { |f, i| FACTORIAL[i] ||= f * i }
  end

  alias_method :fac, :factorial
  alias_method :f!,  :factorial

end

if $0 == __FILE__
  1.upto(8) { |i|
    puts "#{i}: #{i.factorial}"
  }

  require 'benchmark'

  Benchmark.bm(19) { |x|
    [20000, 800, 300, 700, 130, 480, 9999, 9999, 25000].each { |i|
      puts "#{i}:"

      x.report('factorial')          { i.factorial          }
      x.report('factorial_memoized') { i.factorial_memoized }
    }
  }
end
