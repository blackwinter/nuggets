#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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
    replace in_order(*ordered)
  end

end

if $0 == __FILE__
  a = [:created_at, :email, :login, :updated_at]
  p a

  p a.in_order(:login, :email)
  p a.in_order(:email, :address)

  a.in_order!(:login, :email)
  p a
end
