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
  #   array.in_order(*ordered) => new_array
  #
  # Force order, but ignore non-existing and keep remaining.
  #
  # Examples:
  #   [:created_at, :email, :login, :updated_at].in_order(:login, :email)    #=> [:login, :email, :created_at, :updated_at]
  #   [:created_at, :email, :login, :updated_at].in_order(:email, :address)  #=> [:email, :created_at, :login, :updated_at]
  def in_order(*ordered)
    ordered &= self
    ordered + (self - ordered)
  end

  # call-seq:
  #   array.in_order!(*ordered) => array
  #
  # Destructive version of #in_order.
  def in_order!(*ordered)
    replace(in_order(*ordered))
  end

end
