#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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

# Load selected +nuggets+.
#
# Examples:
#   # All String nuggets
#   Nuggets(:string)
#   Nuggets(String)
#
#   # Only 'msub' and 'word_wrap' String nuggets
#   Nuggets(string: %w[msub word_wrap])
#
#   # Selected String nuggets and all Numeric nuggets
#   Nuggets(:numeric, string: %w[msub word_wrap])
#
#   # etc.
def Nuggets(*nuggets)
  loaded_nuggets, load_nuggets = [], lambda { |base, *nuggets|
    nuggets_by_hierarchy = nuggets.last.is_a?(Hash) ? nuggets.pop : {}

    nuggets.each { |nugget|
      begin
        require path = File.join(base.to_s, nugget.to_s.downcase)
        loaded_nuggets << path
      rescue LoadError
        # if it's a directory, load anything in it
        $LOAD_PATH.each { |dir|
          if File.directory?(dir_path = File.join(dir, path))
            load_nuggets[path, *Dir[File.join(dir_path, '*')].map { |file|
              File.basename(file, '.rb') unless file.end_with?('_mixin.rb')
            }.compact]
            break
          end
        } and raise  # otherwise, re-raise
      end
    }

    nuggets_by_hierarchy.each { |hierarchy, nuggets|
      nuggets = [nuggets] if nuggets.is_a?(Hash)
      load_nuggets[File.join(base.to_s, hierarchy.to_s.downcase), *nuggets]
    }
  }

  load_nuggets['nuggets', *nuggets]

  loaded_nuggets
end

require_relative 'nuggets/version'
