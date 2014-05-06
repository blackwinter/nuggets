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
  class Object
    module BooleanMixin

  # call-seq:
  #   object.boolean? => +true+ or +false+
  #
  #
  def boolean?
    is_a?(::TrueClass) || is_a?(::FalseClass)
  end

  # call-seq:
  #   object.negate => +true+ or +false+
  #
  #
  def negate
    !self
  end

  alias_method :false?, :negate

  # call-seq:
  #   object.to_bool => +true+ or +false+
  #
  #
  def to_bool
    !!self
  end

  alias_method :true?, :to_bool

    end
  end
end
