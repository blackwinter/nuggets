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

require 'nuggets/uri/redirect_mixin'
require 'nuggets/net/success'

module Nuggets
  module URI
    module ExistMixin

  def self.extended(base)
    base.extend Nuggets::URI::RedirectMixin
  end

  # call-seq:
  #   URI.exist?(uri) => +true+, +false+ or +nil+
  #   URI.exist?(uri) { |res| ... } => anObject, +false+ or +nil+
  #
  # Checks whether the URI +uri+ exists by performing a +HEAD+ request. If
  # successful, yields the response to the given block and returns its return
  # value, or +true+ if no block was given. Returns +false+ in case of failure,
  # or +nil+ if the redirect limit has been exceeded.
  #
  # See Nuggets::URI::RedirectMixin#follow_redirect for more information.
  def exist?(uri)
    head_redirect(uri) { |res| res.success? && (!block_given? || yield(res)) }
  end

  alias_method :exists?, :exist?

    end
  end
end
