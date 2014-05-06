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

require 'zlib'

module Nuggets
  class Hash
    module ZipMixin

  def zip(*args, &block)
    ZipHash.new(*args, &block)
  end

  def zipval(*args, &block)
    ZipValHash.new(*args, &block)
  end

  def zipkey(*args, &block)
    ZipKeyHash.new(*args, &block)
  end

  class ZipHash < ::Hash

    def [](key)
      unzipval(super(zipkey(key)))
    end

    def []=(key, value)
      super(zipkey(key), zipval(value))
    end

    def fetch(key, *args)
      unzipval(super(zipkey(key), *args))
    end

    def store(key, value)
      super(zipkey(key), zipval(value))
    end

    private

    def zipval(value)
      value.is_a?(ZipVal) ? value : ZipVal.new(value)
    end

    def unzipval(value)
      value.is_a?(ZipVal) ? value.to_s : value
    end

    def zipkey(key)
      key.is_a?(ZipKey) ? key : ZipKey.new(key)
    end

    def unzipkey(key)
      key.is_a?(ZipKey) ? key.to_s : key
    end

  end

  class ZipValHash < ZipHash

    private

    def zipkey(key)
      key
    end

    def unzipkey(key)
      key
    end

  end

  class ZipKeyHash < ZipHash

    private

    def zipval(value)
      value
    end

    def unzipval(value)
      value
    end

  end

  class ZipVal

    include Comparable

    def initialize(value)
      @value = zip(value)
    end

    def <=>(other)
      to_s <=> other.to_s if self.class.equal?(other.class)
    end

    def to_s
      unzip(@value)
    end

    def inspect
      !((s = to_s).length > 64 || s.include?($/)) ? to_s :
        '#<%s:0x%x length=%p>' % [self.class, object_id, @value.length]
    end

    def hash
      to_s.hash
    end

    def eql?(other)
      (self <=> other) == 0
    end

    alias_method :==, :eql?

    private

    def zip(string)
      Zlib::Deflate.deflate(string)
    end

    def unzip(string)
      Zlib::Inflate.inflate(string)
    end

  end

  class ZipKey < ZipVal
  end

    end
  end
end
