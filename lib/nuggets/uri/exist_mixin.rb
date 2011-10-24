#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
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

require 'nuggets/net/success'

module Nuggets
  module URI
    module ExistMixin

  URI_EXIST_HTTP_CACHE = ::Hash.new { |h, k| h[k] = ::Net::HTTP.new(*k) }

  # call-seq:
  #   URI.exist?(uri) => +true+ or +false+
  #
  # Return +true+ if the URI +uri+ exists.
  def exist?(uri, cache = URI_EXIST_HTTP_CACHE, steps = 20, &block)
    uri = ::URI.parse(uri.to_s)
    return unless uri.is_a?(::URI::HTTP)

    res = cache[[uri.host, uri.port]].head(uri.request_uri)

    if res.is_a?(::Net::HTTPRedirection)
      exist?(res['Location'], cache, steps - 1, &block) if steps > 0
    elsif res.success?
      block ? block[res] : true
    else
      false
    end
  rescue ::SocketError, ::Errno::EHOSTUNREACH
  end

  alias_method :exists?, :exist?

    end
  end
end
