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
    module DeepMergeMixin

  # call-seq:
  #   hash.deep_merge(other_hash) => aHash
  #
  # Merges nested hashes recursively (see Hash#merge).
  def deep_merge(other)
    merge(other) { |key, old, new|
      old.respond_to?(:deep_merge) ? old.deep_merge(new) : new
    }
  end

  # call-seq:
  #   hash.deep_merge!(other_hash) => hash
  #
  # Destructive version of #deep_merge.
  def deep_merge!(other)
    replace(deep_merge(other))
  end

  alias_method :deep_update, :deep_merge!

    end
  end
end
