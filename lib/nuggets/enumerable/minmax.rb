#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2015 Jens Wille                                          #
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
  def minmax_by(meth = nil, by = nil, &block)
    return _nuggets_original_minmax_by(&block) unless meth

    _by = by.is_a?(::Proc) ? by : lambda { |i| i.send(by) }
    send(meth) { |a, b| _by[a] <=> _by[b] }
  end

  # call-seq:
  #   enum.max_by(by) => aValue
  #
  # Maximum #minmax_by.
  def max_by(by = nil, &block)
    by.nil? || by.is_a?(::Numeric) ?
      _nuggets_original_max_by(by, &block) : minmax_by(:max, by)
  end

  # call-seq:
  #   enum.min_by(by) => aValue
  #
  # Minimum #minmax_by.
  def min_by(by = nil, &block)
    by.nil? || by.is_a?(::Numeric) ?
      _nuggets_original_min_by(by, &block) : minmax_by(:min, by)
  end

  # call-seq:
  #   enum.minmax(meth, what) => anObject
  #
  # Finds the #minmax_by according to +what+ and returns that "what".
  #
  # Example:
  #   %w[a bcd ef].max(:length)  #=> 3
  def minmax(meth = nil, what = nil, &block)
    return _nuggets_original_minmax(&block) unless meth

    #m = minmax_by(meth, what)
    #what.is_a?(Proc) ? what[m] : m.send(what)

    _what = what.is_a?(::Proc) ? what : lambda { |i| i.send(what) }
    map { |i| _what[i] }.send(meth)

    # Benchmark (:max, :length; enum.size = 20, N = 100_000):
    #
    # max_by(:length).length   7.920000   0.890000   8.810000 (  8.991915)
    # map(:length).max         4.800000   0.600000   5.400000 (  5.418114)
  end

  # call-seq:
  #   enum.max(what) => aValue
  #
  # Maximum #minmax. If +what+ is omitted, or +nil+, the original Enumerable#max
  # is called.
  def max(what = nil, &block)
    what ? minmax(:max, what) : _nuggets_original_max(&block)
  end

  # call-seq:
  #   enum.min(what) => aValue
  #
  # Minimum #minmax. If +what+ is omitted, or +nil+, the original Enumerable#min
  # is called.
  def min(what = nil, &block)
    what ? minmax(:min, what) : _nuggets_original_min(&block)
  end

end
