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
  class Array
    module LimitMixin

  # call-seq:
  #   array.limit(min, max) => anArray
  #
  # Returns a new array of all distinct values in _array_ limited to +min+
  # and +max+ (cf. Numeric#limit). If +uniq+ is +true+, resulting duplicates
  # will be removed.
  def limit(min, max, uniq = true)
    limited = cap(min..max)
    limited.uniq! if uniq
    limited
  end

  alias_method :between, :limit

  def cap(max)
    if max.respond_to?(:begin)
      min, max = max.begin, max.end
      map { |item| item.limit(min, max) }
    else
      map { |item| item.max(max) }
    end
  end

    end
  end
end
