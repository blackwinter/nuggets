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

require 'rubygems'
require 'text'

module Enumerable

  # call-seq:
  #   enum.agrep(pattern[, distance]) => anArray
  #
  # Returns an array of every element in _enum_ for which the Levenshtein
  # distance between +pattern+ and +element+ is at most +distance+. Hence,
  # errors in the match are allowed, similar to what the UNIX tool agrep does.
  #
  # LIMITATIONS:
  #
  # - Only strings are allowed as +pattern+. Regular expressions are reverted
  #   to their respective source. (Equivalent to <tt>agrep -k</tt>)
  # - Only works with string elements in _enum_. (Calls +to_s+ on each element)
  # - The cost for individual error types (substitution, insertion, deletion)
  #   cannot be adjusted.
  def agrep(pattern, distance = 0, cost = 1)
    pattern = pattern.source if pattern.is_a?(Regexp)

    select { |obj|
      Text::Levenshtein.distance(pattern, obj.to_s) * cost <= distance
    }
  end

end

if $0 == __FILE__
  e = %w[quux quuux quix quixx]
  p e

  p e.agrep(/quux/)
  p e.agrep(/quux/, 1)
  p e.agrep(/quux/, 2)

  p e.grep(/qu.x/)
  p e.agrep(/qu.x/)

  p [123, 124, 1233].agrep(/123/, 1)
end
