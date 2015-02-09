#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2015 Jens Wille                                          #
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
    module DeprocMixin

  # call-seq:
  #   hash.deproc -> aProc
  #   hash.deproc { |proc| ... } -> anObject
  #
  # Removes the default proc from _hash_. If a block is given, yields the proc
  # to the block, restores the default proc afterwards and returns the block's
  # return value. Otherwise, returns the proc.
  #
  # Example:
  #
  #   h = Hash.new { |h, k| h[k] = [] }
  #   h.deproc { |_h| Marshal.dump(_h) }  #=> ...dump data...
  #   h.default_proc  #=> #<Proc:...>
  #
  # NOTE: Requires Ruby >= 2.0
  def deproc
    default_proc, self.default_proc = self.default_proc, nil
    return default_proc unless block_given?

    begin
      yield self
    ensure
      self.default_proc = default_proc
    end
  end

  # call-seq:
  #   hash.deproc! -> _hash_ or nil
  #
  # Removes the default proc from _hash_, if present, and returns _hash_.
  # Otherwise, returns +nil+.
  #
  # Example:
  #
  #   h = Hash.new { |h, k| h[k] = [] }
  #   Marshal.dump(h.deproc!)  #=> ...dump data...
  #   h.default_proc  #=> nil
  #
  # NOTE: Requires Ruby >= 2.0
  def deproc!
    return unless default_proc

    self.default_proc = nil
    self
  end

    end
  end
end
