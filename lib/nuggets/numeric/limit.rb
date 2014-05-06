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
  #   num.limit(min, max) => aNumeric
  #
  # Returns +min+ if that's larger than _num_, or +max+ if that's smaller than
  # _num_. Otherwise returns _num_.
  def limit(min, max)
    min, max = max, min if max < min

    min(min).max(max)
  end

  alias_method :between, :limit

  # call-seq:
  #   num.min(min) => aNumeric
  #
  # Returns _num_ or +min+, whatever is larger.
  def min(min)
    self < min ? min : self
  end

  alias_method :at_least, :min

  # call-seq:
  #   num.max(max) => aNumeric
  #
  # Returns _num_ or +max+, whatever is smaller.
  def max(max)
    self > max ? max : self
  end

  alias_method :at_most, :max

end
