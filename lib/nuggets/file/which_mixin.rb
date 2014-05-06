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

require 'rbconfig'

module Nuggets
  class File
    module WhichMixin

  DEFAULT_EXTENSIONS = [::RbConfig::CONFIG['EXEEXT']]

  # call-seq:
  #   File.which(executable[, extensions]) => aString or +nil+
  #
  # Returns +executable+ if it's executable, or the full path to +executable+
  # found in PATH, or +nil+ otherwise. Checks +executable+ with each extension
  # in +extensions+ appended in turn.
  #
  # Inspired by Gnuplot.which -- thx, Gordon!
  def which(executable, extensions = DEFAULT_EXTENSIONS)
    extensions |= ['']

    if env = ::ENV['PATH']
      dirs = env.split(self::PATH_SEPARATOR)
      dirs.map! { |dir| expand_path(dir) }
    end

    extensions.find { |extension|
      file = "#{executable}#{extension}"
      return file if file?(file) && executable?(file)

      dirs.find { |dir|
        path = join(dir, file)
        return path if file?(path) && executable?(path)
      } if dirs
    }
  end

  # call-seq:
  #   File.which_command(commands) => aString or +nil+
  #
  # Returns the first of +commands+ that is executable (according to #which).
  def which_command(commands, extensions = DEFAULT_EXTENSIONS)
    commands.find { |command| which(command.to_s[/\S+/], extensions) }
  end

    end
  end
end
