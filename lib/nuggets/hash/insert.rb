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

class Hash

  # call-seq:
  #   hash.insert(other) => new_hash
  #   hash.insert(other) { |key, old_value, new_value| ... } => new_hash
  #
  # Inserts +other+ into _hash_, while merging existing values instead of just
  # overwriting. Uses default Hash#merge or block for merging.
  def insert(other, &block)
    block ||= lambda { |key, old_val, new_val|
      old_val.is_a?(::Hash) && new_val.is_a?(::Hash) ?
        old_val.merge(new_val, &block) : new_val
    }

    merge(other, &block)
  end

  # call-seq:
  #   hash.insert!(other) => hash
  #   hash.insert!(other) { |key, old_value, new_value| ... } => hash
  #
  # Destructive version of #insert.
  def insert!(other, &block)
    replace(insert(other, &block))
  end

end
