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

class Numeric

  # call-seq:
  #   num.to_multiple_of(target, what) => aNumeric
  #
  # Returns the nearest multiple of +target+ according to +what+.
  def to_multiple_of(target, what = :round)
    target.zero? ? self : (to_f / target).send(what) * target
  end

  # call-seq:
  #   num.round_to(target) => aNumeric
  #
  # Rounds _num_ to the nearest multiple of +target+.
  def round_to(target)
     to_multiple_of(target, :round)
  end

  # call-seq:
  #   num.floor_to(target) => aNumeric
  #
  # Returns the largest multiple of +target+ less than or equal to _num_.
  def floor_to(target)
     to_multiple_of(target, :floor)
  end

  # call-seq:
  #   num.ceil_to(target) => aNumeric
  #
  # Returns the smallest multiple of +target+ greater than or equal to _num_.
  def ceil_to(target)
    to_multiple_of(target, :ceil)
  end

end
