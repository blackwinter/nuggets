#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2009 Jens Wille                                          #
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

if $0 == __FILE__
  [2294967042, 4294967040].each { |i|
    p i.to_binary_s(32)
    p i.to_dotted_decimal
  }

  puts '#' * 34

  %w[77.47.161.3 196.101.53.1].each { |s|
    p s
    p s.from_dotted_decimal.to_binary_s(32)
  }

  a = %w[77.47.161.3 196.101.53.1 77.47.161.11]
  p a.sort
  p a.sort_by_dotted_decimal
end
