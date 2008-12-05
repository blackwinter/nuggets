#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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

class Array

  # call-seq:
  #   array.monotone?(operator) => true or false
  #
  # Check whether _array_ is monotone according to +operator+.
  def monotone?(operator)
    inject { |a, b|
      return false unless a.send(operator, b)
      b
    }

    true
  end
  alias_method :monotonic?, :monotone?

  # call-seq:
  #   array.ascending? => true or false
  #
  # Check whether _array_ is (strictly) ascending.
  def ascending?(strict = false)
    monotone?(strict ? :< : :<=)
  end
  alias_method :increasing?, :ascending?

  # call-seq:
  #   array.strictly_ascending? => true or false
  #
  # Check whether _array_ is strictly ascending.
  def strictly_ascending?
    ascending?(true)
  end
  alias_method :strictly_increasing?, :strictly_ascending?

  # call-seq:
  #   array.descending? => true or false
  #
  # Check whether _array_ is (strictly) descending.
  def descending?(strict = false)
    monotone?(strict ? :> : :>=)
  end
  alias_method :decreasing?, :descending?

  # call-seq:
  #   array.strictly_descending? => true or false
  #
  # Check whether _array_ is strictly descending.
  def strictly_descending?
    descending?(true)
  end
  alias_method :strictly_decreasing?, :strictly_descending?

end

if $0 == __FILE__
  a = [1, 2, 3, 4]
  p a

  p a.ascending?           # => true
  p a.strictly_ascending?  # => true
  p a.descending?          # => false

  b = [1, 2, 4, 3]
  p b

  p b.ascending?           # => false
  p b.descending?          # => false

  c = [1, 2, 4, 4]
  p c

  p c.ascending?           # => true
  p c.strictly_ascending?  # => false
end
