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

module Nuggets
  class String
    module XorMixin

  # call-seq:
  #   str ^ other => new_string
  #   str.xor(other) => new_string
  #
  # Bitwise EXCLUSIVE OR.
  def xor(other, require_same_length = false)
    format = 'B*'
    binary = [self, other.to_s].map { |s| s.unpack(format).first }

    length = binary.map { |s| s.length }.inject { |a, b|
      if require_same_length
        a == b ? a : raise(::ArgumentError, 'must be of same length')
      else
        [a, b].max
      end
    }

    [binary.map { |s| s.to_i(2) }.
            inject { |a, b| a ^ b }.
            to_binary_s(length)].pack(format)
  end

  alias_method :^, :xor

    end
  end
end
