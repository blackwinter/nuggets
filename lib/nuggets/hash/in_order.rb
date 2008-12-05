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

require 'nuggets/array/in_order'

class Hash

  # call-seq:
  #   hash.in_order(*ordered) => anArray
  #
  # Returns <tt>hash#to_a</tt>, in forced order (cf. Array#in_order).
  #
  # Examples:
  #   { :a => 1, :b => 2, :c => 3 }.in_order(:b, :c)  #=> [[:b, 2], [:c, 3], [:a, 1]]
  #   { :a => 1, :b => 2, :c => 3 }.in_order(:b, :d)  #=> [[:b, 2], [:a, 1], [:c, 3]]
  def in_order(*ordered)
    keys.in_order(*ordered).map { |key| [key, self[key]] }
  end

end

if $0 == __FILE__
  a = { :a => 1, :b => 2, :c => 3 }
  p a

  p a.in_order(:b, :c)
  p a.in_order(:b, :d)
end
