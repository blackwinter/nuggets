#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2009 Jens Wille                                          #
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
  # Calculates the standard deviation of the items contained in _array_.
  def standard_deviation
    begin
      Math.sqrt(block_given? ? variance { |*a| yield(*a) } : variance)
    rescue Errno::EDOM
      0.0
    end
  end

  alias_method :std, :standard_deviation

    end
  end
end
