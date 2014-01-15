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

require 'rdf/util'

begin
  require 'zlib'
rescue LoadError => err
  warn err if $VERBOSE
end

begin
  require 'rbzip2'

  class RBzip2::Decompressor

    def eof?
      @current_state == EOF
    end

    def gets(sep = $/)
      r = ''

      loop {
        b = read0
        break if b < 0

        count(1)
        r << b

        break if r.end_with?(sep)
      }

      r
    end

  end
rescue LoadError => err
  warn err if $VERBOSE
end

class << RDF::Util::File

  alias_method :_nuggets_original_open_file, :open_file

  def open_file(filename_or_url, options = {}, &block)
    klass = begin
      case File.extname(filename_or_url).downcase.sub(/\A\./, '')
        when /\Abz(?:ip)?2?\z/ then RBzip2::Decompressor
        when /\Agz(?:ip)?\z/   then Zlib::GzipReader
      end
    rescue NameError => err
      err.message.sub!('Module::', '')
      raise
    end

    if klass
      original_block, block = block, lambda { |file|
        original_block[file.is_a?(IO) ? klass.new(file) : file]
      }
    end

    _nuggets_original_open_file(filename_or_url, options, &block)
  end

end
