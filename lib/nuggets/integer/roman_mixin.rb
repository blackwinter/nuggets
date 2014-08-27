#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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
  class Integer
    module RomanMixin

  NUMERAL = {
    1000 => 'M',
    500  => 'D',
    100  => 'C',
    50   => 'L',
    10   => 'X',
    5    => 'V',
    1    => 'I'
  }

  COMPACT = NUMERAL.values.each_cons(3).to_a.values_at(0, 2, 4).flat_map { |*a, b|
    a.push(nil).each_cons(2).map { |x, y| [/#{y}#{b}{4}/, "#{b}#{x}"] }
  }

  # call-seq:
  #   to_roman(int) => aString
  #
  # Converts _positive_ integer +int+ to Roman numerals.
  def self.to_roman(int, num = '')
    NUMERAL.each { |key, val|
      until int < key; int -= key; num << val; end
    }

    COMPACT.each { |key, val| num.gsub!(key, val) }

    num
  end

  # call-seq:
  #   int.to_roman => aString
  #
  # Converts _int_ to Roman numerals.
  def to_roman
    self == 0 ? 'N' : self < 0 ?
      RomanMixin.to_roman(-self, '-') : RomanMixin.to_roman(self)
  end

    end
  end
end
