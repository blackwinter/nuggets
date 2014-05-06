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

require 'nuggets/array/histogram_mixin'

module Nuggets
  class Array
    module ModeMixin

  def self.included(base)
    base.send :include, Nuggets::Array::HistogramMixin
  end

  # call-seq:
  #   array.mode => anObject
  #   array.mode(+true+) => anArray
  #
  # Returns the mode[http://en.wikipedia.org/wiki/Mode_%28statistics%29] of
  # the values in _array_ (via #histogram).
  #
  # If parameter +true+ is passed, an Array of all modes is returned.
  def mode(all = false, &block)
    hist, modes = histogram(&block), []
    freq = hist.values.max

    hist.each { |key, value|
      if value == freq
        modes << key
        break unless all
      end
    }

    all ? modes : modes.first
  end

  # call-seq:
  #   array.modes => anArray
  #
  # Returns an Array of all modes of the values in _array_ (see #mode).
  def modes(&block)
    mode(true, &block)
  end

    end
  end
end
