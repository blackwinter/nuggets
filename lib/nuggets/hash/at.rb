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

require 'nuggets/array/rand'

class Hash

  # call-seq:
  #   hash.at(what) => aHash
  #
  # Returns the key/value pair of _hash_ at key position +what+. Remember that
  # hashes might not have the intended (or expected) order in pre-1.9 Ruby.
  def at(what, &block)
    return {} if empty?

    key = what.is_a?(::Integer) ? keys[what] : keys.send(*what, &block)

    { key => self[key] }
  end

  # call-seq:
  #   hash.first => aHash
  #
  # Returns the "first" key/value pair of _hash_.
  def first
    at(:first)
  end

  # call-seq:
  #   hash.last => aHash
  #
  # Returns the "last" key/value pair of _hash_.
  def last
    at(:last)
  end

  # call-seq:
  #   hash.rand => aHash
  #
  # Returns a random key/value pair of _hash_.
  def rand
    at(:rand)
  end

end
