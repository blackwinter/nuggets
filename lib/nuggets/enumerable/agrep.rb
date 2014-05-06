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

begin
  require 'rubygems'
rescue ::LoadError
end

begin
  require 'amatch'
rescue ::LoadError
  warn "Couldn't load amatch..." if $VERBOSE
end

module Enumerable

  # call-seq:
  #   enum.agrep(pattern[, distance]) -> anArray
  #   enum.agrep(pattern[, distance]) { |element| ... } -> enum
  #
  # Returns an array of all elements in _enum_ for which +pattern+ approximately
  # matches +element+ (see Amatch::Levenshtein#search). If the optional +block+
  # is supplied, each matching element is passed to it, and the _enum_ itself is
  # returned.
  #
  # LIMITATIONS:
  #
  # - Only strings are allowed as +pattern+. Regular expressions are reverted
  #   to their respective source. (Equivalent to <tt>agrep -k</tt>)
  # - Only works with string elements in _enum_. (Calls +to_s+ on each element)
  # - The cost for individual error types (substitution, insertion, deletion)
  #   cannot be adjusted.
  def agrep(pattern, distance = 0)
    pattern = pattern.source if pattern.is_a?(::Regexp)

    am = ::Amatch::Levenshtein.new(pattern)
    ma = lambda { |i| am.search(i.to_s) <= distance }

    block_given? ? each { |i| yield i if ma[i] } : select(&ma)
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

  #p [123, 124, 1233].agrep(/123/, 1)
end
