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
  def to_hash(value = default = Object.new)
    hash = {}

    if block_given?
      raise ArgumentError, "both block and value argument given" if default.nil?

      each { |element| hash[element] = yield element }
    elsif default.nil?
      each { |element| hash[element] = value }
    else
      return Hash[*flatten_once]
    end

    hash
  end
  alias_method :to_h, :to_hash

end

if $0 == __FILE__
  a = [[:a, 1], [:b, 2], [:c, 3]]
  p a
  p a.to_h

  b = [[:a, [1, 2]], [:b, 3], [[:c, :d], [4, [5, 6]]]]
  p b
  p b.to_h

  c = %w[a b c d]
  p c
  p c.to_h
  p c.to_h(1)
  p c.to_h { nil }

  h = { :a => 1, :b => [2, 3], :c => { :d => 4}}
  p h
  p h.to_a
  p h.to_a.to_h
  p h.to_a.to_h == h
end
