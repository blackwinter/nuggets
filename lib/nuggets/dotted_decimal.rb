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

require 'nuggets/integer/to_binary_s'

class Integer

  # call-seq:
  #   int.to_dotted_decimal => aString
  #
  # Converts _int_ to dotted-decimal notation.
  def to_dotted_decimal
    to_binary_s(32).unpack('a8' * 4).map { |s| s.to_i(2) }.join('.')
  end

end

class String

  # call-seq:
  #   str.from_dotted_decimal => anInteger
  #
  # Converts _str_ from dotted-decimal notation to integer.
  def from_dotted_decimal
    split('.').map { |i| i.to_i.to_binary_s(8) }.join.to_i(2)
  end

end

class Array

  def sort_by_dotted_decimal
    sort_by { |i| i.split('.').map { |j| j.to_i } }
  end

end
