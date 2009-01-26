#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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

require 'nuggets/string/evaluate'

class String

  # call-seq:
  #   str.msub(*substitutions) => new_str
  #
  # Performs _multiple_ substitutions on _str_ with order being taken into
  # account (thus results of previous substitutions won't be subject to later
  # ones) -- inspired by Ruby Cookbook example 1.18.
  #
  # The +substitutions+ parameter can be an array or a list of <tt>[pattern,
  # substitution]</tt> pairs, or, simply, a hash. Note that, when using a hash,
  # the ordering of how substitutions are processed might differ from what you
  # intended -- instead use an array when order matters. +pattern+ can be a
  # string or a regexp, +substitution+ may contain string expressions (cf.
  # #evaluate).
  def msub(*substitutions)
    (_dup = dup).msub!(*substitutions) || _dup
  end

  # call-seq:
  #   str.msub!(*substitutions) => str or nil
  #
  # Destructive version of #msub.
  def msub!(*substitutions)
    substitutions = substitutions.first if substitutions.first.is_a?(Hash)

    binding = substitutions.is_a?(Hash) ? substitutions.delete(:__binding__) :
      substitutions.last.is_a?(Hash) ? substitutions.pop[:__binding__] : nil
    binding ||= Kernel.binding

    keys, subs, cache = [], [], {}

    substitutions.each { |key, value|
      key = Regexp.new(Regexp.escape(key)) unless key.is_a?(Regexp)

      keys << key
      subs << [key, value]
    }

    gsub!(Regexp.union(*keys)) { |match|
      cache[match] ||= begin
        eval("__match__ = #{match.inspect}", binding)
        subs.find { |key, _| key =~ match }.last.evaluate(binding)
      end
    }
  end

end

if $0 == __FILE__
  s = 'Foo, Bar - Baz'
  p s

  p s.gsub(/a/, 'o').gsub(/o/, 'a')
  p s.msub('a' => 'o', 'o' => 'a')

  s.msub!('a' => 'o', 'o' => 'a')
  p s

  t = '!!!'
  begin
    p s.msub('r' => '???', 'z' => '#{t}')
  rescue NameError => err
    warn err
  end
  p s.msub('r' => '???', 'z' => '#{t}', :__binding__ => binding)

  p s.msub(/[A-Z]/ => '#{__match__.downcase}', :__binding__ => binding)
end
