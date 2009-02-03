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

module Nuggets
  class Object
    module BooleanMixin

  # call-seq:
  #   object.boolean? => true or false
  #
  #
  def boolean?
    is_a?(::TrueClass) || is_a?(::FalseClass)
  end

  # call-seq:
  #   object.negate => true or false
  #
  #
  def negate
    !self
  end

  alias_method :false?, :negate

  # call-seq:
  #   object.to_bool => true or false
  #
  #
  def to_bool
    !!self
  end

  alias_method :true?, :to_bool

    end
  end
end
