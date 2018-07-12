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
    module CanonicalMixin

  def generate_canonical(obj, opts = {})
    generate(_nuggets_json_canonical(obj), opts)
  end

  def pretty_generate_canonical(obj, opts = {})
    pretty_generate(_nuggets_json_canonical(obj), opts)
  end

  def pretty_print_canonical(source, opts = {})
    pretty_generate_canonical(parse_multi(source, opts), opts)
  end

  alias_method :pc, :pretty_print_canonical

  private

  def _nuggets_json_canonical(obj)
    case obj
      when ::Hash
        obj.class.new.tap { |res|
          obj.keys.sort.each { |k| res[k] = send(__method__, obj[k]) } }
      when ::Array
        obj.map { |v| send(__method__, v) }.sort_by(&:to_s)
      else
        obj
    end
  end

    end
  end
end
