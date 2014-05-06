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

require 'nuggets/array/flatten_once'

class Array

  # call-seq:
  #   array.to_hash => aHash
  #   array.to_hash(value) => aHash
  #   array.to_hash { |element| ... } => aHash
  #
  # If neither +value+ nor block is given, converts _array_, taken as an
  # array of key/value pairs, into a hash, preserving sub-arrays (Thus:
  # <tt>hash.to_a.to_h == hash</tt>). Otherwise, maps each element of
  # _array_ to +value+ or the result of the block.
  #
  # Examples:
  #   [[0, 0], [1, [2, 3]]].to_h  #=> { 0 => 0, 1 => [2, 3] }
  #   %w[a b c d].to_h            #=> { "a" => "b", "c" => "d" }
  #   %w[a b c d].to_h(1)         #=> { "a" => 1, "b" => 1, "c" => 1, "d" => 1 }
  #   %w[a b].to_h { |e| e * 2 }  #=> { "a" => "aa", "b" => "bb" }
  def to_hash(value = default = true)
    hash = {}

    if block_given?
      raise ::ArgumentError, 'both block and value argument given' unless default

      each { |element| hash[element] = yield element }
    elsif !default
      each { |element| hash[element] = value }
    else
      return ::Hash[*flatten_once]
    end

    hash
  end

  alias_method :to_h, :to_hash

end
