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

require 'nuggets/array/combination'

class Array

  # call-seq:
  #   array % other_array => aString
  #   array % str         => aString
  #
  # Format--Uses the first string in _array_ for which the corresponding
  # combination of _other_array_ does not contain blank elements as a format
  # specification, and returns the result of applying it to that combination
  # (cf. String#%). Returns an empty string if _other_array_ is empty.
  #
  # Applies to string argument accordingly: First string in _array_ applied to
  # _str_; empty string if _str_ is empty.
  def %(args)
    opts = { sep: ', ' }
    opts.update(pop) if last.is_a?(::Hash)

    default = lambda { |n| ['%s'] * n * opts[:sep] }

    case args
      when ::String
        return (first || default[1]) % args unless
          args.nil? || args.empty?
      when ::Array
        i = 0
        [*args].comb { |x|
          return (self[i] || default[x.size]) % x unless
            x.empty? || x.any? { |y| y.nil? || y.empty? }

          i += 1
        }
    end

    ''
  end

end
