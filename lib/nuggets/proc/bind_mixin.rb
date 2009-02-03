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
  class Proc
    module BindMixin

  # call-seq:
  #   proc.bind(object) => aMethod
  #
  # Straight from Rails' ActiveSupport -- effectively binds _proc_ to +object+.
  def bind(object)
    block, time = self, ::Time.now

    (class << object; self; end).class_eval {
      method_name = "__bind_#{time.to_i}_#{time.usec}"
      define_method(method_name, &block)

      method = instance_method(method_name)
      remove_method(method_name)

      method
    }.bind(object)
  end

    end
  end
end
