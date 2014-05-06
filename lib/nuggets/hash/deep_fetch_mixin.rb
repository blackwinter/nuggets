#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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

module Nuggets
  class Hash
    module DeepFetchMixin

  # call-seq:
  #   hash.deep_fetch(path[, separator]) => anObject
  #   hash.deep_fetch(path[, separator]) { |key| ... } => anObject
  #
  # Recursively fetches keys in +path+, separated by +separator+
  # if +path+ is not an array, from _hash_. Maps each individual
  # key according to the block if provided.
  #
  # Examples:
  #
  #   hash = { 'foo' => { 'bar' => { 'baz' => 42 }, 'bay' => 23 } }
  #   hash.deep_fetch('foo/bar/baz') #=> 42
  #   hash.deep_fetch('foo/bar/bax') #=> nil
  #   hash.deep_fetch('foo/bax/baz') #=> KeyError
  #   hash.deep_fetch('foo/bay/baz') #=> TypeError
  #   hash % 'foo/bar/baz' #=> 42
  #   hash % %w[foo bar baz] #=> 42
  #
  #   hash = { foo: { bar: { baz: 42 } } }
  #   hash.deep_fetch('foo/bar/baz', &:to_sym) #=> 42
  #   hash % [:foo, :bar, :baz] #=> 42
  def deep_fetch(path, separator = '/')
    keys = path.is_a?(::Array) ? path : path.split(separator)
    raise ::ArgumentError, 'no keys given' if keys.empty?

    hash, klass = self, self.class

    loop {
      key = keys.shift
      key = yield key if block_given?

      return hash[key] if keys.empty?

      unless (hash = hash.fetch(key)).is_a?(klass)
        raise ::TypeError, '%p: %s expected, got %s' % [key, klass, hash.class]
      end
    }
  end

  alias_method :%, :deep_fetch

    end
  end
end
