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

begin
  require 'filemagic/ext'
rescue LoadError
  def File.content_type(path)  # :nodoc:
    nil
  end
end

begin
  require 'nuggets/uri/content_type'
rescue LoadError
  module URI
    def self.content_type(path)  # :nodoc:
      nil
    end
  end
end

begin
  require 'mime/types'
rescue LoadError
  module MIME    # :nodoc:
    class Types  # :nodoc:
      def self.of(path)
        []
      end
    end
  end
end

module Nuggets
  module ContentType

    extend self

    # call-seq:
    #   ContentType.of(path) => aString or +nil+
    #
    # Get the MIME-Type of the file living at +path+. Either by looking
    # directly into the file (requires FileMagic), or, assuming +path+
    # might denote a URI, by asking the web server (via OpenURI), or
    # finally by just looking at the file extension (requires MIME::Types).
    # Returns +nil+ in case no decision could be made.
    #
    # NOTE: This is really only useful with the filemagic and mime-types gems
    # installed.
    def of(path)
      ::File.content_type(path) || ::URI.content_type(path) || (
        t = ::MIME::Types.of(path).first and t.content_type
      )
    end

  end
end

# Just a short-cut to make the code read nicer...
ContentType = ::Nuggets::ContentType

if $0 == __FILE__
  [
    __FILE__,
    'bla/blub.jpg',
    'bla/blub.blob',
    'http://www.google.de',
    'http://blackwinter.de/misc/ww.png',
    'http://blackwinter.de/misc/ww.jpg',
    'http://blackwinter.de/bla/blub.blob'
  ].each { |f|
    p [f, ::ContentType.of(f)]
  }
end
