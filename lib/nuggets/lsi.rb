#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2013 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# ruby-nuggets is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.        #
#                                                                             #
###############################################################################
#++

require 'gsl'

module Nuggets

  class LSI

    include Enumerable

    def initialize(items = {})
      @hash, @list, @invlist = {}, Hash.new { |h, k| h[k] = h.size }, {}
      items.each { |k, v| self[k] = v }
    end

    def [](key)
      @hash[key]
    end

    def []=(key, value)
      @hash[key] = Doc.new(value, @list)
    end

    def add(key, value = key)
      self[key] = value
      self
    end

    def <<(value)
      add(value.object_id, value)
    end

    def size
      @hash.size
    end

    def keys
      @hash.keys
    end

    def docs
      @hash.values
    end

    def each(&block)
      @hash.each(&block)
    end

    def each_norm(key, min = nil)
      if d = self[key] and n = d.norm
        l, i = @invlist, 0
        n.each { |v| yield l[i], v unless min && v < min; i += 1 }
      end
    end

    def build(cutoff = 0.75)
      build!(docs, @list, cutoff) if size > 1
    end

    private

    def build!(docs, list, cutoff)
      u, v, s = GSL::Matrix.alloc(*vectors(docs, list)).trans.SV_decomp
      reduce(u, v, cutoff(s, cutoff), docs)
      size
    end

    def vectors(docs, list)
      @invlist, size = list.invert, list.size
      docs.map { |doc| transform(doc.raw_vector(size)) }
    end

    # FIXME: "first-order association transform" ???
    def transform(vec, q = 0)
      return vec #unless (sum = vec.sum) > 1

      vec.each { |v| q -= (w = v / sum) * Math.log(w) if v > 0 }
      vec.map! { |v| Math.log(v + 1) / q }
    end

    def cutoff(s, c)
      w, i = s.sort[-(s.size * c).round], 0
      s.each { |v| s[i] = 0 if v < w; i += 1 }
      s
    end

    def reduce(u, v, s, d, i = -1)
      (u * GSL::Matrix.diagonal(s) * v.trans).each_col { |c|
        d[i += 1].vector = c.row
      }
    end

    class Doc

      TOKEN_RE = %r{\s+}

      def initialize(item, list)
        item = build_hash(item) unless item.is_a?(Hash)
        @map = item.map { |k, v| [list[k], v] }
      end

      attr_reader :vector, :norm

      def raw_vector(size)
        vec = GSL::Vector.alloc(size)
        @map.each { |k, v| vec[k] = v }
        vec
      end

      def vector=(vec)
        @vector, @norm = vec, vec.normalize
      end

      private

      def build_hash(item, hash = Hash.new(0))
        build_array(item).each { |i| hash[i] += 1 }
        hash
      end

      def build_array(item, re = TOKEN_RE)
        item = item.read if item.respond_to?(:read)
        item = item.split(re) if item.respond_to?(:split)
        item
      end

    end

  end

end
