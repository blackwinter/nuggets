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

require 'nuggets/hash/at'

class Hash

  # call-seq:
  #   hash.only(relax = true or false) => aHash
  #
  # Returns the only key/value pair of _hash_. Raises an IndexError if _hash_'s
  # size is not 1, unless +relax+ is true.
  def only(relax = size == 1, split = false)
    raise IndexError, 'not a single-element hash' unless relax

    split ? Array(*first) : first
  end

  # call-seq:
  #   hash.only_pair(relax = true or false) => anArray
  #
  # Returns the only key/value pair of _hash_ as an array. Raises an IndexError
  # if _hash_'s size is not 1, unless +relax+ is true.
  def only_pair(relax = size == 1)
    only(relax, true)
  end

end

if $0 == __FILE__
  [{ :a => 5 }, { 1 => 2, 3 => 4 }, {}].each { |h|
    p h

    begin
      p h.only
      p h.only_pair
    rescue IndexError => err
      warn err
    end

    p h.only(true)
  }
end
