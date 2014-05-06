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
  class String
    module EvaluateMixin

  # call-seq:
  #   str.evaluate([binding, [filename, [lineno]]]) => new_str
  #
  # Basically turns Kernel#eval into an instance method of String -- inspired
  # by Ruby Cookbook example 1.3. This allows to pre-populate strings with
  # substitution expressions <tt>"#{...}"</tt> that can get evaluated in a
  # different environment (= +binding+) at a later point.
  #
  # Passes optional arguments +filename+ and +lineno+ on to Kernel#eval.
  def evaluate(binding = ::TOPLEVEL_BINDING, filename = nil, lineno = nil)
    buffer = gsub(/\\*"/) { |m| "#{"\\" * m.length}#{m}" }
    eval(%Q{"#{buffer}"}, binding, filename || __FILE__, lineno || __LINE__)
  end

    end
  end
end
