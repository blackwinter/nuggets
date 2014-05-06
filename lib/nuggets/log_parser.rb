#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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
  module LogParser

    extend self

    GZ_EXT_RE = %r{\.gz\z}

    def self.register(base, *modules)
      base.send(:include, *modules << self)
      base.extend(base)
    end

    def parse(input)
      entry = {}

      input.each { |line| parse_line(line, entry) {
        unless entry.empty?
          yield entry.dup
          entry.clear
        end
      } }

      yield entry unless entry.empty?
    end

    def parse_line(line, entry = {})
      # Yield when entry complete. Preferrably return +entry+.
      raise NotImplementedError, 'must be implemented by type'
    end

    def parse_file(file, &block)
      block ||= (entries = []; lambda { |entry| entries << entry })

      (file =~ GZ_EXT_RE ? Zlib::GzipReader : ::File).open(file) { |f|
        block.arity == 1 ? parse(f, &block) : block[f, method(:parse)]
      }

      entries
    end

  end
end
