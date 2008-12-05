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

begin
  require 'rubygems'
rescue LoadError
end

begin
  require 'amatch'
rescue LoadError
  warn "Couldn't load amatch..." if $VERBOSE
end

module Enumerable

  # call-seq:
  #   enum.agrep(pattern[, distance]) => anArray
  #   enum.agrep(pattern[, distance]) { |obj| ... } => anArray
  #
  # Returns an array of every element in _enum_ for which +pattern+ approximately
  # matches +element+ (see Amatch::Levenshtein#search). If the optional +block+
  # is supplied, each matching element is passed to it, and the block‘s result
  # is stored in the output array.
  #
  # LIMITATIONS:
  #
  # - Only strings are allowed as +pattern+. Regular expressions are reverted
  #   to their respective source. (Equivalent to <tt>agrep -k</tt>)
  # - Only works with string elements in _enum_. (Calls +to_s+ on each element)
  # - The cost for individual error types (substitution, insertion, deletion)
  #   cannot be adjusted. 
  def agrep(pattern, distance = 0)
    raise 'Amatch not available!' unless defined?(Amatch)

    pattern = pattern.source if pattern.is_a?(Regexp)

    amatch  = Amatch::Levenshtein.new(pattern)
    matches = select { |obj| amatch.search(obj.to_s) <= distance }

    block_given? ? matches.map { |match| yield match } : matches
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
