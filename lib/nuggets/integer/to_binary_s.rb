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

  # call-seq:
  #   int.to_binary_s => aString
  #   int.to_binary_s(length) => aString
  #
  # Returns _int_ as binary number string; optionally zero-padded to +length+.
  def to_binary_s(length = nil)
    "%0#{length}d" % to_s(2)
  end

end

if $0 == __FILE__
  [20000, 800, 300, 700, 130, 480, 9999, 9999, 25000].each { |i|
    p i
    p i.to_binary_s
    p i.to_binary_s(32)
  }
end
