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

class Array

  # call-seq:
  #   array.flatten_once => new_array
  #
  # Flatten _array_ by _one_ level only. Pretty straight-forward port of David
  # Alan Black's flattenx C implementation (though much slower, of course ;-).
  def flatten_once
    flat = []

    each { |element|
      if element.is_a?(::Array)
        flat += element
      else
        flat << element
      end
    }

    flat
  end

  # call-seq:
  #   array.flatten_once! => array
  #
  # Destructive version of #flatten_once.
  def flatten_once!
    replace(flatten_once)
  end

end
