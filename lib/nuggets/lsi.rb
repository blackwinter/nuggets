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

require 'forwardable'
require 'gsl'

module Nuggets

  class LSI

    include ::Enumerable

    extend ::Forwardable

    DEFAULT_EPSILON   = ::Float::EPSILON * 10

    DEFAULT_PRECISION = 2

    DEFAULT_TRANSFORM = :tfidf

    DEFAULT_CUTOFF    = 0.75

    class << self

      def build(items, options = {})
        lsi = new(items)
        lsi if lsi.build(options)
      end

      def each_norm(items, options = {}, build_options = {}, &block)
        lsi = new(items)
        lsi.each_norm(nil, options, &block) if lsi.build(build_options)
      end

    end

    def initialize(items = {})
      reset
      items.each { |k, v| self[k] = v || k }
    end

    def_delegators :@hash, :[], :each, :include?, :key, :keys, :size

    def_delegator  :@hash, :values,    :docs
    def_delegator  :@hash, :values_at, :docs_at

    def_delegator  :@list, :keys, :terms

    alias_method :doc, :[]

    def []=(key, value)
      @hash[key] = Doc.new(key, value, @list, @freq)
    end

    def add(key, value = key)
      self[key] = value
      self
    end

    def <<(value)
      add(value.object_id, value)
    end

    # min:: minimum value to consider
    # abs:: minimum absolute value to consider
    # nul:: exclude null values (true or Float)
    # new:: exclude original terms / only yield new ones
    def each_term(key = nil, options = {})
      return enum_for(:each_term, key, options) unless block_given?

      min, abs, nul, new = options.values_at(:min, :abs, :nul, :new)
      nul = DEFAULT_EPSILON if nul == true

      list, norm = @invlist, options[:norm]

      (key ? [self[key]] : docs).each { |doc|
        if doc && vec = norm ? doc.norm : doc.vector
          vec.enum_for(:each).with_index { |v, i|
            yield doc, list[i], v unless v.nan? ||
                                         (min && v < min) ||
                                         (abs && v.abs < abs) ||
                                         (nul && v.abs < nul) ||
                                         (new && doc.include?(i))
          }
        end
      }
    end

    def each_norm(key = nil, options = {}, &block)
      each_term(key, options.merge(:norm => true), &block)
    end

    def related(key, num = 5)
      if doc = self[key] and norm = doc.norm
        temp = sort_by { |k, v| -norm * v.norm.col }
        temp.map! { |k,| k }.delete(key)
        temp[0, num]
      end
    end

    def related_score(key, num = 5)
      if doc = self[key] and norm = doc.norm
        temp = map { |k, v| [k, norm * v.norm.col] }.sort_by { |_, i| -i }
        temp.delete(temp.assoc(key))
        temp[0, num]
      end
    end

    def build(options = {})
      build!(docs, @list, options.is_a?(::Hash) ?
        options : { :cutoff => options }) if size > 1
    end

    def reset
      @hash, @list, @freq, @invlist =
        {}, ::Hash.new { |h, k| h[k] = h.size }, ::Hash.new(0), {}
    end

    def inspect
      '%s@%d/%d' % [self.class, size, @list.size]
    end

    def to_a(norm = true)
      (norm ? map { |_, doc| doc.norm.to_a } :
              map { |_, doc| doc.vector.to_a }).transpose
    end

    private

    def build!(docs, list, options)
      Doc.transform = options.fetch(:transform, DEFAULT_TRANSFORM)

      @invlist = list.invert

      # TODO: GSL::ERROR::EUNIMPL: Ruby/GSL error code 24, svd of
      # MxN matrix, M<N, is not implemented (file svd.c, line 61)
      u, v, s = matrix(docs, list.size, size = docs.size).SV_decomp

      (u * reduce(s, options.fetch(:cutoff, DEFAULT_CUTOFF)) * v.trans).
        enum_for(:each_col).with_index { |c, i| docs[i].vector = c.row }

      size
    end

    def matrix(d = docs, m = @list.size, n = d.size)
      x = ::GSL::Matrix.alloc(m, n)
      d.each_with_index { |i, j| x.set_col(j, i.transformed_vector(m, n)) }
      x
    end

    # k == nil:: keep all
    # k >= 1::   keep this many
    # k < 1::    keep (at most) this proportion
    def reduce(s, k, m = s.size)
      if k && k < m
        k > 0 ? s[k = (k < 1 ? m * k : k).floor, m - k] = 0 : s.set_zero
      end

      s.to_m_diagonal
    end

    class Doc

      include ::Enumerable

      extend ::Forwardable

      TOKEN_RE = %r{\s+}

      class << self

        attr_reader :transform

        def transform=(transform)
          method = :transformed_vector

          case transform
            when ::Proc          then define_method(method, &transform)
            when ::UnboundMethod then define_method(method, transform)
            else alias_method(method, "#{transform ||= :raw}_vector")
          end

          @transform = transform.to_sym
        end

      end

      def initialize(key, value, list, freq)
        @key, @list, @freq, @total = key, list, freq, 1

        @map = !value.is_a?(::Hash) ? build_hash(value, list) :
          value.inject({}) { |h, (k, v)| h[list[k]] = v; h }

        @map.each_key { |k| freq[k] += 1 }

        self.vector = raw_vector
      end

      attr_reader :key, :vector, :norm

      def_delegators :@map, :each, :include?

      def_delegator :raw_vector, :sum, :size

      def raw_vector(size = @list.size, *)
        vec = ::GSL::Vector.calloc(size)
        each { |k, v| vec[k] = v }
        vec
      end

      # TODO: "first-order association transform" ???
      def foat_vector(*args)
        vec, q = raw_vector(*args), 0
        return vec unless (s = vec.sum) > 1

        vec.each { |v| q -= (w = v / s) * ::Math.log(w) if v > 0 }
        vec.map { |v| ::Math.log(v + 1) / q }
      end

      def tfidf_vector(*args)
        vec, f = raw_vector(*args), @freq
        s, d = vec.sum, @total = args.fetch(1, @total).to_f

        vec.enum_for(:map).with_index { |v, i|
          v > 0 ? ::Math.log(d / f[i]) * v / s : v }
      end

      self.transform = DEFAULT_TRANSFORM

      def vector=(vec)
        @vector, @norm = vec, vec.normalize
      end

      def inspect
        '%s@%p/%d' % [self.class, key, size]
      end

      private

      def build_hash(value, list, hash = ::Hash.new(0))
        build_enum(value).each { |i| hash[list[i]] += 1 }
        hash
      end

      def build_enum(value, re = TOKEN_RE)
        value = value.read if value.respond_to?(:read)
        value = value.split(re) if value.respond_to?(:split)
        value
      end

    end

  end

end
