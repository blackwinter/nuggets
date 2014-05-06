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

require 'nuggets/array/variance_mixin'

module Nuggets
  class Array
    module StandardDeviationMixin

  def self.included(base)
    base.send :include, Nuggets::Array::VarianceMixin
  end

  # call-seq:
  #   array.standard_deviation => aFloat
  #
  # Calculates the {standard deviation}[http://en.wikipedia.org/wiki/Standard_deviation]
  # of the values in _array_.
  def standard_deviation(&block)
    ::Math.sqrt(variance(&block))
  end

  alias_method :std, :standard_deviation

    end
  end
end
