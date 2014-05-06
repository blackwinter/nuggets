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

require 'net/https'

module Nuggets
  module URI
    module RedirectMixin

  # Maximum number of redirects to follow.
  URI_REDIRECT_MAX_STEPS = 20

  # Cache for HTTP objects to reuse.
  URI_REDIRECT_HTTP_CACHE = ::Hash.new { |h, k| h[k] = ::Net::HTTP.new(*k) }

  # call-seq:
  #   URI.follow_redirect(uri[, steps]) { |req, path| ... } => aResponse or +nil+
  #
  # Performs any HTTP request on +uri+ while following at most +steps+ redirects.
  # Accepts both strings and URI objects for +uri+. Defers to the given block to
  # perform the actual request; yields the request object and the request URI
  # string.
  #
  # Returns the response object if successful, or +nil+ if +uri+ is not an HTTP
  # URI, the redirect limit has been exceeded, or any connection error occurs.
  def follow_redirect(uri, steps = URI_REDIRECT_MAX_STEPS, cache = URI_REDIRECT_HTTP_CACHE)
    unless uri.is_a?(::URI::HTTP)
      uri = ::URI.parse(uri.to_s)
      return unless uri.is_a?(::URI::HTTP)
    end

    req = cache[[uri.host, uri.port]]
    req.use_ssl = uri.is_a?(::URI::HTTPS)

    ctx = req.instance_variable_get(:@ssl_context) if req.use_ssl?
    ctx.verify_mode ||= ::OpenSSL::SSL::VERIFY_NONE if ctx

    res = yield req, uri.request_uri
    return res unless res.is_a?(::Net::HTTPRedirection)
    return nil unless steps > 0

    follow_redirect(res['Location'], steps - 1, cache) { |*a| yield(*a) }
  rescue ::SocketError, ::Errno::EHOSTUNREACH, ::Errno::ENOENT
  end

  # call-seq:
  #   URI.head_redirect(uri[, steps]) => aResponse or +nil+
  #   URI.head_redirect(uri[, steps]) { |res| ... } => anObject or +nil+
  #
  # Performs a +HEAD+ request on +uri+ while following at most +steps+ redirects.
  # If successful, yields the response to the given block and returns its return
  # value, or the response itself if no block was given. Returns +nil+ in case
  # of failure.
  #
  # See Nuggets::URI::RedirectMixin#follow_redirect for more information.
  def head_redirect(uri, steps = URI_REDIRECT_MAX_STEPS)
    res = follow_redirect(uri, steps) { |req, path| req.head(path) }
    res && block_given? ? yield(res) : res
  end

  # call-seq:
  #   URI.get_redirect(uri[, steps]) => aResponse or +nil+
  #   URI.get_redirect(uri[, steps]) { |res| ... } => anObject or +nil+
  #
  # Performs a +GET+ request on +uri+ while following at most +steps+ redirects.
  # If successful, yields the response to the given block and returns its return
  # value, or the response itself if no block was given. Returns +nil+ in case
  # of failure.
  #
  # See Nuggets::URI::RedirectMixin#follow_redirect for more information.
  def get_redirect(uri, steps = URI_REDIRECT_MAX_STEPS)
    res = follow_redirect(uri, steps) { |req, path| req.get(path) }
    res && block_given? ? yield(res) : res
  end

    end
  end
end
