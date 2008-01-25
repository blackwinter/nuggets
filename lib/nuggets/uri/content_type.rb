#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2008 Jens Wille                                          #
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

require 'open-uri'

module URI

  class << self

    # call-seq:
    #   URI.content_type(uri) => aString or nil
    #
    # Return the content type of +uri+, or +nil+ if not found.
    def content_type(uri)
      open(uri.to_s).content_type
    rescue OpenURI::HTTPError, SocketError, Errno::ENOENT
      nil
    end

  end

end

if $0 == __FILE__
  %w[
    http://www.google.de
    htp://www.google.de
    www.google.de
    http://blackwinter.de/misc/
    http://blackwinter.de/misc/ww.png
    http://blackwinter.de/misc/suicide_is_painless.mid
    http://blackwinter.de/misc/expand_macros.pl.gz
    http://blackwinter.de/misc/blanc60302523.nth
  ].each { |u|
    p [u, URI.content_type(u)]
  }
end
