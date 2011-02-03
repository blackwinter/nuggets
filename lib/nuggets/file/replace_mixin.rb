#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
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

module Nuggets
  class File
    module ReplaceMixin

  # call-seq:
  #   File.replace(name, create_if_missing = false) { ... } => aString
  #   File.replace(name, create_if_missing = false) { |content| ... } => aString
  #
  # Replaces the contents of file +name+ with the result of the block. Yields
  # the file's contents to the block if requested. Returns the new content.
  #
  # If +create_if_missing+ is true and the file does not exist, it will be
  # created.
  def replace(name, create_if_missing = false, &block)
    open(name, create_if_missing && !exist?(name) ? 'w+' : 'r+') { |f|
      content = block.arity != 0 ? yield(f.read) : yield

      f.truncate(0)
      f.rewind

      f.print content

      content
    }
  end

    end
  end
end
