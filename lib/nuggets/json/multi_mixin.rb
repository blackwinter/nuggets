#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2018 Jens Wille                                          #
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
  module JSON
    module MultiMixin

  # Preserves multiple (non-unique) names in
  # {"non-interoperable"}[https://tools.ietf.org/html/rfc7159#section-4] JSON objects.
  def parse_multi(source, opts = {})
    parse(source, opts.merge(object_class: MULTI_OBJECT))
  end

  def pretty_print_multi(source, opts = {})
    pretty_generate(parse_multi(source, opts), opts)
  end

  alias_method :pp, :pretty_print_multi

  private

  class MULTI_OBJECT < ::Hash

    def []=(k, v)
      super(MULTI_KEY.new(k), v)
    end

    def each_multi(k)
      block_given? ? each { |l, v| yield v if k == l } : enum_for(__method__, k)
    end

    def fetch_multi(k)
      each_multi(k).to_a
    end

  end

  class MULTI_KEY < ::String

    def eql?(*)
      false
    end

  end

    end
  end
end
