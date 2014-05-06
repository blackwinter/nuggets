#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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
    module SeenMixin

  # call-seq:
  #   Hash.seen([seen[, unseen]]) => aHash
  #
  # Returns a hash that returns +unseen+ as the default value for a key that
  # wasn't seen before and +seen+ for a key that was.
  #
  # Examples:
  #
  #   hash = Hash.seen
  #   hash[:foo]  #=> false
  #   hash[:foo]  #=> true
  #   hash[:foo]  #=> true
  #   hash[:bar]  #=> false
  #   hash[:bar]  #=> true
  #
  #   hash = Hash.seen(42, 23)
  #   hash[:foo]  #=> 23
  #   hash[:foo]  #=> 42
  #   hash[:foo]  #=> 42
  #   hash[:bar]  #=> 23
  #   hash[:bar]  #=> 42
  def seen(seen = true, unseen = false)
    new { |hash, key| hash[key] = seen; unseen }
  end

    end
  end
end
