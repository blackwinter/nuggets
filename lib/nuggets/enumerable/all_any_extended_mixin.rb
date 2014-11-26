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
  module Enumerable
    module AllAnyExtendedMixin

  # call-seq:
  #   enum.all?(obj[, operator]) => +true+ or +false+
  #   enum.all? { ... } => +true+ or +false+
  #
  # Adds the ability to pass an +object+ instead of a block, which will then
  # be tested against each item in _enum_ according to +operator+, defaulting
  # to <tt>:===</tt>.
  def all?(object = default = true, operator = :===, &block)
    super(&_block_for_all_any_extended(object, default, operator, &block))
  end

  # call-seq:
  #   enum.any?(obj[, operator]) => +true+ or +false+
  #   enum.any? { ... } => +true+ or +false+
  #
  # Adds the ability to pass an +object+ instead of a block, which will then
  # be tested against each item in _enum_ according to +operator+, defaulting
  # to <tt>:===</tt>.
  def any?(object = default = true, operator = :===, &block)
    super(&_block_for_all_any_extended(object, default, operator, &block))
  end

  private

  # Common argument processing for extended versions of #all? and #any?.
  def _block_for_all_any_extended(object, default, operator, &block)
    default ? block : begin
      raise ::ArgumentError, 'both block and object argument given', caller(1) if block
      lambda { |*a| object.send(operator, *a) }
    end
  end

    end
  end
end
