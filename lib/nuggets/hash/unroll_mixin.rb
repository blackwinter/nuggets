#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2009 Jens Wille                                          #
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

module Nuggets
  class Hash
    module UnrollMixin

  # call-seq:
  #   hash.unroll(*value_keys) => anArray
  #   hash.unroll(*value_keys, :sort => ...) => anArray
  #   hash.unroll(*value_keys) { |value_hash| ... } => anArray
  #
  # "Unrolls" a nested hash, so that each path through _hash_ results in a
  # row that is, e.g., suitable for use with CSV.
  #
  # Note that from the final hash ("value hash") only the values are used,
  # namely, if +value_keys+ are given, the values at those keys are returned.
  # If a block is given, the +value_hash+ is passed to that block for any
  # additional processing or sanitization.
  #
  # If +sort_by+ is given, all hashes are passed through that block for
  # sorting before being put into the result array.
  #
  # Examples:
  #
  #   { :foo => { :bar => { :a => { :x => 1, :y => 2 }, :b => { :x => 0, :y => 3 } } } }.unroll
  #   #=> [[:foo, :bar, :b, 3, 0], [:foo, :bar, :a, 2, 1]]
  #
  #   { :foo => { :bar => { :a => { :x => 1, :y => 2 }, :b => { :x => 0, :y => 3 } } } }.unroll(:sort_by => :to_s)
  #   #=> [[:foo, :bar, :a, 1, 2], [:foo, :bar, :b, 0, 3]]
  #
  #   { :foo => { :bar => { :a => { :x => 1, :y => 2 }, :b => { :x => 0, :y => 3 } } } }.unroll { |data| data[:x] = nil; data[:y] *= 2 }
  #   #=> [[:foo, :bar, :b, 6, nil], [:foo, :bar, :a, 4, nil]]
  def unroll(*value_keys, &block)
    args = value_keys.dup
    options = value_keys.last.is_a?(::Hash) ? value_keys.pop : {}

    do_sort = if options.has_key?(:sort_by)
      lambda { sort_by(&options[:sort_by]) }
    elsif options.has_key?(:sort)
      sort_opt = options[:sort]

      if sort_opt == true
        lambda { sort }
      elsif sort_opt.respond_to?(:to_proc)
        lambda { sort(&sort_opt) }
      end
    end

    rows = []

    if values.first.is_a?(self.class)  # if any is, then all are
      (do_sort ? do_sort.call : self).each { |key, value|
        value.unroll(*args, &block).each { |row| rows << [key, *row] }
      }
    else
      block[self] if block

      rows << if value_keys.empty?
        do_sort ? do_sort.call.map { |key, value| value } : values
      else
        values_at(*value_keys)
      end
    end

    rows
  end

    end
  end
end
