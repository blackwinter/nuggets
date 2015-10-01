#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2015 Jens Wille                                          #
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
  class File
    module OpenFileMixin

  # call-seq:
  #   File.open_file(filename[, options[, mode]]) -> anIO
  #   File.open_file(filename[, options[, mode]]) { |io| ... } => anObject
  #
  # Supported options are +mode+ (defaults to +r+) and +encoding+ (defaults
  # to the default external encoding).
  #
  # If +filename+ is +-+, sets +io+ to +STDOUT+ when in write mode or +STDIN+
  # otherwise. Puts +io+ into binary mode if requested. Sets +io+'s encoding.
  #
  # If +filename+ ends with +.gz+ or +.gzip+, uses Zlib for reading or writing
  # the file.
  #
  # Otherwise defers to ::open.
  #
  # Yields +io+ to the given block or returns it when no block given.
  def open_file(filename, options = {}, mode = 'r', &block)
    mode = options.fetch(:mode, mode); writing = mode =~ /w/

    encoding = options.fetch(:encoding, ::Encoding.default_external)

    case filename
      when '-'
        io = writing ? $stdout : $stdin
        io.binmode if mode =~ /b/
        io.set_encoding(encoding)

        block ? block[io] : io
      when /\.gz(?:ip)?\z/i
        require 'zlib'

        klass = writing ? ::Zlib::GzipWriter : ::Zlib::GzipReader
        klass.open(filename, encoding: encoding, &block)
      else
        open(filename, mode, encoding: encoding, &block)
    end
  end

    end
  end
end
