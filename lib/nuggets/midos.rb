# encoding: utf-8

#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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

require 'nuggets/midos/base'
require 'nuggets/midos/reader'
require 'nuggets/midos/writer'

module Nuggets
  module Midos

    # Record separator
    DEFAULT_RS = '&&&'

    # Field separator
    DEFAULT_FS = ':'

    # Value separator
    DEFAULT_VS = '|'

    # Line break indicator
    DEFAULT_NL = '^'

    # Line ending
    DEFAULT_LE = "\r\n"

    # Default file encoding
    DEFAULT_ENCODING = 'iso-8859-1'

    class << self

      def filter(source, target, source_options = {}, target_options = source_options)
        writer, size = Writer.new(target_options.merge(:io => target)),  0

        Reader.parse(source, source_options) { |*args|
          writer << args and size += 1 if yield(*args)
        }

        size
      end

      def filter_file(source_file, target_file, source_options = {}, target_options = source_options, &block)
        open_file(source_file, source_options) { |source|
          open_file(target_file, target_options, 'w') { |target|
            filter(source, target, source_options, target_options, &block)
          }
        }
      end

      def convert(*args)
        filter(*args) { |*| true }
      end

      def convert_file(*args)
        filter_file(*args) { |*| true }
      end

      def open_file(file, options = {}, mode = 'r', &block)
        encoding = options[:encoding] ||= DEFAULT_ENCODING
        ::File.open(file, mode, :encoding => encoding, &block)
      end

    end

  end
end