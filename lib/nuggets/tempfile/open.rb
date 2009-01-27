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

require 'tempfile'

class Tempfile

  class << self

    alias_method :_nuggets_original_open, :open

    # If no block is given, this is a synonym for new().
    #
    # If a block is given, it will be passed tempfile as an argument,
    # and the tempfile will automatically be closed when the block
    # terminates.  In this case, open() returns tempfile -- in contrast
    # to the original implementation, which returns nil.
    def open(*args)
      tempfile = new(*args)

      if block_given?
        begin
          yield tempfile
        ensure
          tempfile.close
        end
      end

      tempfile
    end

  end

end
