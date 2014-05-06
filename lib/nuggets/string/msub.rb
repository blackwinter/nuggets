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
  # string or a regexp, +substitution+ can be a string (which may contain string
  # expressions; cf. #evaluate), a proc (which will be call()ed), or any object
  # really (which will be converted into a string).
  def msub(*substitutions)
    (_dup = dup).msub!(*substitutions) || _dup
  end

  # call-seq:
  #   str.msub!(*substitutions) => str or +nil+
  #
  # Destructive version of #msub.
  def msub!(*substitutions)
    options = substitutions.last.is_a?(::Hash) ? substitutions.pop : {}
    binding = options.delete(:__binding__) || ::Kernel.binding

    keys, subs, cache = [], [], {}

    substitutions.concat(options.to_a).each { |key, value|
      key = ::Regexp.new(::Regexp.escape(key)) unless key.is_a?(::Regexp)

      keys << key
      subs << [key, value]
    }

    gsub!(::Regexp.union(*keys)) { |match|
      cache[match] ||= begin
        value = subs.find { |key, _| key =~ match }.last

        if value.respond_to?(:evaluate)
          # make match available for string evaluation
          eval("__match__ = #{match.inspect}", binding)

          value.evaluate(binding)
        elsif value.respond_to?(:call)
          value.call(match)
        else
          value
        end
      end
    }
  end

end
