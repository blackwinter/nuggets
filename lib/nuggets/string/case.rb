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

  module Case

    LOWER = :lower
    UPPER = :upper
    MIXED = :mixed

  end

  # call-seq:
  #   str.case => aSymbol
  #
  # Returns a symbol indicating the case of _str_.
  def case
    self == downcase ? Case::LOWER :
    self == upcase   ? Case::UPPER :
                       Case::MIXED
  end

  # call-seq:
  #   str.lower_case? => true or false
  #
  # Tell whether _str_ is all lower case.
  def lower_case?
    self.case == Case::LOWER
  end
  alias_method :downcase?, :lower_case?

  # call-seq:
  #   str.upper_case? => true or false
  #
  # Tell whether _str_ is all upper case.
  def upper_case?
    self.case == Case::UPPER
  end
  alias_method :upcase?, :upper_case?

  # call-seq:
  #   str.mixed_case? => true or false
  #
  # Tell whether _str_ is mixed case.
  def mixed_case?
    self.case == Case::MIXED
  end

  # call-seq:
  #   str.capitalized? => true or false
  #
  # Tell whether _str_ is capitalized.
  def capitalized?
    self == capitalize
  end

end

if $0 == __FILE__
  s = 'Some string'
  puts s
  p    s.case
  puts s.downcase?
  puts s.upcase?
  puts s.mixed_case?
  puts s.capitalized?

  s = 'some string'
  puts s
  p    s.case
  puts s.downcase?
  puts s.mixed_case?

  s = 'SOME STRING'
  puts s
  p    s.case
  puts s.upcase?
  puts s.mixed_case?
end
