#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2016 Jens Wille                                          #
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
  class String
    module FormatMixin

  PREFIX = '%'

  FORMAT_RE = %r{#{PREFIX}(?:\{(.*?)\}|(.))}o

  # call-seq:
  #   str.format(hash) => aString
  #   str.format { |directive| ... } => aString
  #
  # Replace format directives in _str_.
  #
  # If +hash+ given, uses value of directive key (String or Symbol)
  # as replacement value. Raises KeyError if directive key not found.
  #
  # If block given, uses result of +directive+ yielded to block as
  # replacement value. Raises ArgumentError if block returns no value.
  def format(hash = nil)
    replace = lambda { |&b| gsub(FORMAT_RE) {
      (k = $1 || $2) == PREFIX ? k : b[k] } }

    hash ? replace.() { |k| hash.fetch(k) {
      hash.fetch(k.to_sym) { raise(KeyError, "key not found: #{k}") } } } :
    block_given? ? replace.() { |k| yield k or
      raise(ArgumentError, "malformed format string - #{$&}") } :
      raise(ArgumentError, 'wrong number of arguments (given 0, expected 1)')
  end

    end
  end
end
