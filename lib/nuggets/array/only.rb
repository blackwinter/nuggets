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

class Array

  # call-seq:
  #   array.only(relax = true or false) => anObject
  #
  # Returns the only element of _array_. Raises an IndexError if _array_'s
  # size is not 1, unless +relax+ is true.
  #
  # Idea stolen from Gavin Sinclair's Ruby Extensions Project.
  def only(relax = size == 1)
    raise IndexError, 'not a single-element array' unless relax
    first
  end

end

if $0 == __FILE__
  [[5], [1, 2, 3], []].each { |a|
    p a

    begin
      p a.only
    rescue IndexError => err
      warn err
    end

    p a.only(true)
  }
end
