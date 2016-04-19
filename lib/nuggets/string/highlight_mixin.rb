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
    module HighlightMixin

  # call-seq:
  #   str.highlight(needle[, prefix[, postfix]]) => new_string
  #
  # Highlight occurrences of +needle+ (String(s) and/or Regexp(s))
  # in _str_ by surrounding them with +prefix+ and +postfix+.
  def highlight(needle, prefix = '|', postfix = prefix)
    offsets = []

    Array(needle).each { |arg|
      while index = index(arg, index || 0)
        offsets << [index, index += ($& || arg).length]
      end
    }

    flattened = [current = offsets.sort!.shift]

    offsets.each { |offset|
      i1, j1 = current
      i2, j2 = offset

      i2 > j1 ? flattened << current = offset :
      j2 > j1 ? current[-1] = j2 : nil
    }

    dup.tap { |result| flattened.reverse_each { |i, j|
      result.insert(j, postfix).insert(i, prefix)
    } }
  end

    end
  end
end
