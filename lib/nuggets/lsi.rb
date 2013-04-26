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

    DEFAULT_EPSILON = Float::EPSILON * 10

    def self.each_norm(items, options = {}, &block)
      lsi = new(items)
      lsi.each_norm(nil, options, &block) if lsi.build
    end

    def initialize(items = {})
      @hash, @list, @invlist = {}, Hash.new { |h, k| h[k] = h.size }, {}
      items.each { |k, v| self[k] = v }
    end

    def [](key)
      @hash[key]
    end

    def []=(key, value)
      @hash[key] = Doc.new(key, value, @list)
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

    # min:: minimum value to consider
    # abs:: minimum absolute value to consider
    # nul:: exclude null values (true or Float)
    # new:: exclude original terms / only yield new ones
    def each_norm(key = nil, options = {})
      min, abs, nul, new = options.values_at(:min, :abs, :nul, :new)
      nul = DEFAULT_EPSILON if nul == true

      list = @invlist

      (key ? [self[key]] : docs).each { |doc|
        if doc && norm = doc.norm
          i = 0

          norm.each { |v|
            yield doc, list[i], v unless (min && v < min) ||
                                         (abs && v.abs < abs) ||
                                         (nul && v.abs < nul) ||
                                         (new && doc.include?(i))
            i += 1
          }
        end
      }
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

      def initialize(key, value, list)
        @key = key
        @map = !value.is_a?(Hash) ? build_hash(value, list) :
          value.inject({}) { |h, (k, v)| h[list[k]] = v; h }
      end

      attr_reader :key, :vector, :norm

      def raw_vector(size)
        vec = GSL::Vector.alloc(size)
        @map.each { |k, v| vec[k] = v }
        vec
      end

      def vector=(vec)
        @vector, @norm = vec, vec.normalize
      end

      def include?(k)
        @map.include?(k)
      end

      private

      def build_hash(value, list, hash = Hash.new(0))
        build_array(value).each { |i| hash[list[i]] += 1 }
        hash
      end

      def build_array(value, re = TOKEN_RE)
        value = value.read if value.respond_to?(:read)
        value = value.split(re) if value.respond_to?(:split)
        value
      end

    end

  end

end
