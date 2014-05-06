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

module Nuggets
  class Hash
    module NestMixin

  # call-seq:
  #   Hash.nest([depth]) => aHash
  #   Hash.nest([depth[, value]]) => aHash
  #   Hash.nest([depth]) { |key| ... } => aHash
  #
  # Creates a nested hash, +depth+ levels deep. The final hash will receive a
  # default value of +value+ or, if +value+ is not given but a block is given,
  # the result of the key yielded to that block, or, otherwise, the hash's
  # original default value, typically +nil+.
  #
  # NOTE: If you set the default value for one of the nested hashes explicitly,
  # all of the effects described here disappear for that hash because that also
  # means that the default proc will be cleared.
  #
  # Example:
  #
  #   hash = Hash.nest(3)
  #   hash[:foo][:bar][:a] = { :x => 1, :y => 2 }
  #   hash[:foo][:bar][:b] = { :x => 0, :y => 3 }
  #   hash
  #   #=> {:foo=>{:bar=>{:b=>{:y=>3, :x=>0}, :a=>{:y=>2, :x=>1}}}}
  def nest(depth = 0, value = default = true)
    if depth.zero?
      if default
        if block_given?
          new { |hash, key| hash[key] = yield(key) }
        else
          new { |hash, key| hash[key] = hash.default }
        end
      else
        new { |hash, key| hash[key] = value }
      end
    else
      if default
        if block_given?
          new { |hash, key| hash[key] = nest(depth - 1, &::Proc.new) }
        else
          new { |hash, key| hash[key] = nest(depth - 1) }
        end
      else
        new { |hash, key| hash[key] = nest(depth - 1, value) }
      end
    end
  end

    end
  end
end
