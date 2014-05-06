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

module Nuggets
  module Env
    module SetMixin

  # call-seq:
  #   ENV.set([env[, clear]]) => aHash
  #   ENV.set([env[, clear]]) { ... } => anObject
  #
  # Overrides ENV with +env+, clearing it beforehand if +clear+ is +true+. If a
  # block is given, restores ENV to its original state afterwards and returns
  # the result of the block; otherwise returns the original ENV as a hash.
  def set(env = {}, clear = true)
    old_env = to_hash

    self.clear if clear

    env.each { |key, value|
      key = key.to_s.upcase unless key.is_a?(::String)
      value = value.to_s unless value.is_a?(::String)

      self[key] = value
    }

    block_given? ? yield : old_env
  ensure
    set(old_env) if old_env && block_given?
  end

  alias_method :without, :set

  # call-seq:
  #   ENV.with([env[, clear]]) { ... } => anObject
  #
  # Temporarily overrides ENV with +env+ for the block execution. See #set.
  def with(env = {}, clear = false)
    set(env, clear) { yield }
  end

    end
  end
end
