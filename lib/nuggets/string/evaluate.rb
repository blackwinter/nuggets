#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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

class String

  # call-seq:
  #   str.evaluate(binding = TOPLEVEL_BINDING) => new_str
  #
  # Basically turns Kernel#eval into an instance method of String -- inspired
  # by Ruby Cookbook example 1.3. This allows to pre-populate strings with
  # substitution expressions ("#{...}") that can get evaluated in a different
  # environment (= +binding+) at a later point.
  def evaluate(binding = TOPLEVEL_BINDING)
    eval(%Q{%Q{#{self}}}, binding)
  end

end

if $0 == __FILE__
  s = 'bl#{a}blub'
  p s

  def foo(bar) # :nodoc:
    a = 'ub'
    bar.evaluate(binding)
  end

  p foo(s)

  p 'a"b"c'.evaluate(binding)
end
