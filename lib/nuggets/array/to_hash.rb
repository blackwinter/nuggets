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

require File.join(File.dirname(__FILE__), 'flatten_once')

class Array

  # call-seq:
  #   array.to_h => aHash
  #   array.to_h(value) => aHash
  #   array.to_h { |element| ... } => aHash
  #
  # If neither +value+ nor block is given, converts _array_, taken as an
  # array of key/value pairs, into a hash, preserving sub-arrays (Thus:
  # <tt>hash.to_a.to_h == hash</tt>). Otherwise, maps each element of
  # _array_ to +value+ or the result of the block.
  #
  # NOTE: This is the "nice" version. For a more speed-optimized one,
  # use #to_hash_opt.
  #
  # Examples:
  #   [[0, 0], [1, [2, 3]]].to_h  #=> { 0 => 0, 1 => [2, 3] }
  #   %w[a b c d].to_h            #=> { "a" => "b", "c" => "d" }
  #   %w[a b c d].to_h(1)         #=> { "a" => 1, "b" => 1, "c" => 1, "d" => 1 }
  #   %w[a b].to_h { |e| e * 2 }  #=> { "a" => "aa", "b" => "bb" }
  def to_hash(value = default = Object.new, &block)
    if block ||= value != default && lambda { value }
      inject({}) { |hash, element|
        hash.update(element => block[element])
      }
    else
      Hash[*flatten_once]
    end
  end
  alias_method :to_h, :to_hash

  # call-seq:
  #   array.to_h => aHash
  #   array.to_h(value) => aHash
  #   array.to_h { |element| ... } => aHash
  #
  # Same as #to_hash, but slightly optimized for speed. To use this one instead
  # of #to_hash: <tt>class Array; alias_method :to_h, :to_hash_opt; end</tt>.
  #
  # Benchmark (array = (1..20).to_a, N = 100_000):
  #                            user     system      total        real
  #   to_hash: plain       4.820000   0.560000   5.380000 (  5.600390)
  #   to_hash: value      12.910000   0.930000  13.840000 ( 13.938352)
  #   to_hash: block      13.590000   1.180000  14.770000 ( 14.810804)
  #   to_hash_opt: plain   4.910000   0.470000   5.380000 (  5.416949)
  #   to_hash_opt: value   2.170000   0.390000   2.560000 (  2.609034)
  #   to_hash_opt: block   7.090000   0.880000   7.970000 (  8.109180)
  def to_hash_opt(value = default = Object.new, &block)
    if block
      hash = {}
      each { |element| hash[element] = block[element] }
      hash
    elsif value != default
      hash = {}
      each { |element| hash[element] = value }
      hash
    else
      Hash[*flatten_once]
    end
  end
  #alias_method :to_h, :to_hash_opt

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
