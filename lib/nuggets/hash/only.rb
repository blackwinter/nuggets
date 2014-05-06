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

require 'nuggets/hash/at'

class Hash

  # call-seq:
  #   hash.only => aHash
  #   hash.only(+true+) => aHash
  #
  # Returns the only key/value pair of _hash_. Raises an IndexError if _hash_'s
  # size is not 1, unless parameter +true+ is passed.
  def only(relax = size == 1, split = false)
    relax ? split ? Array(*first) : first :
      raise(::IndexError, 'not a single-element hash')
  end

  # call-seq:
  #   hash.only_pair => anArray
  #   hash.only_pair(+true+) => anArray
  #
  # Returns the only key/value pair of _hash_ as an array. Raises an IndexError
  # if _hash_'s size is not 1, unless parameter +true+ is passed.
  def only_pair(relax = size == 1)
    only(relax, true)
  end

end
