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

module Enumerable

  alias_method :_nuggets_original_minmax_by, :minmax_by if method_defined?(:minmax_by)
  alias_method :_nuggets_original_min_by,    :min_by    if method_defined?(:min_by)
  alias_method :_nuggets_original_max_by,    :max_by    if method_defined?(:max_by)
  alias_method :_nuggets_original_minmax,    :minmax    if method_defined?(:minmax)

  alias_method :_nuggets_original_max, :max
  alias_method :_nuggets_original_min, :min

  # call-seq:
  #   enum.minmax_by(meth, by) => aValue
  #
  # Finds the maximum/minimum (or whatever +meth+ is) value in _enum_ according
  # to +by+ (which may be a symbol/string that is sent to each value, or a proc
  # that receives each value as parameter).
  def minmax_by(meth, by)
    _by = by.is_a?(Proc) ? by : lambda { |i| i.send(by) }
    send(meth) { |a, b| _by[a] <=> _by[b] }
  end

  # call-seq:
  #   enum.max_by(by) => aValue
  #
  # Maximum #minmax_by.
  def max_by(by)
    minmax_by(:max, by)
  end

  # call-seq:
  #   enum.min_by(by) => aValue
  #
  # Minimum #minmax_by.
  def min_by(by)
    minmax_by(:min, by)
  end

  # call-seq:
  #   enum.minmax(meth, what) => anObject
  #
  # Finds the #minmax_by according to +what+ and returns that "what".
  #
  # Example:
  #   %w[a bcd ef].max(:length)  #=> 3
  def minmax(meth, what)
    #m = minmax_by(meth, what)
    #what.is_a?(Proc) ? what[m] : m.send(what)

    _what = what.is_a?(Proc) ? what : lambda { |i| i.send(what) }
    map { |i| _what[i] }.send(meth)

    # Benchmark (:max, :length; enum.size = 20, N = 100_000):
    #
    # max_by(:length).length   7.920000   0.890000   8.810000 (  8.991915)
    # map(:length).max         4.800000   0.600000   5.400000 (  5.418114)
  end

  # call-seq:
  #   enum.max(what) => aValue
  #
  # Maximum #minmax. If +what+ is omitted, or nil, the original Enumerable#max
  # is called.
  def max(what = nil)
    what ? minmax(:max, what) : block_given? ?
      _nuggets_original_max { |*a| yield(*a) } : _nuggets_original_max
  end

  # call-seq:
  #   enum.min(what) => aValue
  #
  # Minimum #minmax. If +what+ is omitted, or nil, the original Enumerable#min
  # is called.
  def min(what = nil)
    what ? minmax(:min, what) : block_given? ?
      _nuggets_original_min { |*a| yield(*a) } : _nuggets_original_min
  end

end

if $0 == __FILE__
  e = %w[quux quuux quix]
  p e

  p e.max
  p e.max_by(:length)
  p e.max(:length)

  e = [3, 222, 45]
  p e

  # the last digit counts ;-)
  l = lambda { |i| i.to_s.split(//).last.to_i }

  p e.max
  p e.max_by(l)
  p e.max(l)
end
