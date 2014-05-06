#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2013 Jens Wille                                          #
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
  module Argv
    module OptionMixin

  # call-seq:
  #   ARGV.switch(short[, long]) -> true | false
  #
  # Whether ARGV includes the switch +short+ (or +long+).
  def switch(*args)
    !!(__key(*args) { |key| include?(key) })
  end

  # call-seq:
  #   ARGV.option(short[, long]) -> aString
  #   ARGV.option(short[, long]) { |value| ... } -> anObject
  #
  # Returns the value associated with the option +short+ (or +long+) if present
  # in ARGV. Yields that value to the block if given and returns its result.
  def option(*args, &block)
    __opt(block, *args) { |index| at(index + 1) }
  end

  # call-seq:
  #   ARGV.switch!(short[, long]) -> true | false
  #
  # Whether ARGV includes the switch +short+ (or +long+). Removes the matching
  # switch from ARGV.
  def switch!(*args)
    !!(__key(*args) { |key| delete(key) })
  end

  # call-seq:
  #   ARGV.option!(short[, long]) -> aString
  #   ARGV.option!(short[, long]) { |value| ... } -> anObject
  #
  # Returns the value associated with the option +short+ (or +long+) if present
  # in ARGV and removes both from ARGV. Yields that value to the block if given
  # and returns its result.
  def option!(*args, &block)
    __opt(block, *args) { |index| delete_at(index); delete_at(index) }
  end

  private

  def __key(short, long = nil)  # :yield: key
    long && yield("--#{long}") || yield("-#{short}")
  end

  def __opt(block, *args)
    index = __key(*args) { |key| index(key) } or return

    value = yield(index)
    block ? block[value] : value
  end

    end
  end
end
