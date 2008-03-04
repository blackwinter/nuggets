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

class String

  # call-seq:
  #   str.capitalize_first => new_string
  #
  # Capitalizes the first character in +str+, but without downcasing the rest
  # like String#capitalize does.
  def capitalize_first
    return self if empty?
    self[0..0].upcase << self[1..-1]
  end

  # call-seq:
  #   str.capitalize_first! => str
  #
  # Destructive version of #capitalize_first.
  def capitalize_first!
    replace capitalize_first
  end

end

if $0 == __FILE__
  s = 'Some string'
  p s
  p s.capitalize_first

  s = 'some string'
  p s
  p s.capitalize_first

  s = 'SOME STRING'
  p s
  p s.capitalize
  p s.capitalize_first
end
