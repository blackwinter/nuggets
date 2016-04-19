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

require 'nuggets/array/in_order'

class Hash

  # call-seq:
  #   hash.in_order(*ordered) => anArray
  #
  # Returns <tt>hash#to_a</tt>, in forced order (cf. Array#in_order).
  #
  # Examples:
  #   { a: 1, b: 2, c: 3 }.in_order(:b, :c)  #=> [[:b, 2], [:c, 3], [:a, 1]]
  #   { a: 1, b: 2, c: 3 }.in_order(:b, :d)  #=> [[:b, 2], [:a, 1], [:c, 3]]
  def in_order(*ordered)
    keys.in_order(*ordered).map { |key| [key, self[key]] }
  end

end
