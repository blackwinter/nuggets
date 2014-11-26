#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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
    module RescueIfMixin

  # call-seq:
  #   rescue_if([args]) { |err| ... }
  #
  # Rescue exceptions matching +args+, or StandardError if not given,
  # if +block+ returns true.
  def rescue_if(*args, &block)
    raise ::ArgumentError, 'no block given' unless block

    args = [::StandardError] if args.empty?

    ::Module.new {
      define_singleton_method(:===) { |err|
        block[err] if args.any? { |arg| arg === err }
      }
    }
  end

  # call-seq:
  #   rescue_unless([args]) { |err| ... }
  #
  # Rescue exceptions matching +args+, or StandardError if not given,
  # unless +block+ returns true.
  def rescue_unless(*args, &block)
    raise ::ArgumentError, 'no block given' unless block

    rescue_if(*args) { |err| !block[err] }
  end

    end
  end
end
