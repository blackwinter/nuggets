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

class File

  class << self

    # call-seq:
    #   File.which(executable) => aString or nil
    #
    # Returns the full path to +executable+, or +nil+ if not found in PATH.
    # Inspired by Gnuplot.which -- thx, Gordon!
    def which(executable)
      return executable if executable?(executable)

      if path = ENV['PATH']
        path.split(PATH_SEPARATOR).each { |dir|
          candidate = join(expand_path(dir), executable)
          return candidate if executable?(candidate)
        }
      end

      nil
    end

    # call-seq:
    #   File.which_command(commands) => aString or nil
    #
    # Returns the first of +commands+ that is executable.
    def which_command(commands)
      commands.find { |command| which(command[/\S+/]) }
    end

  end

end

if $0 == __FILE__
  %w[cat dog rat gcc /usr/bin/X11/gcc].each { |e|
    p [e, File.which(e)]
  }

  c = [
    'unison --args source target',
    'rsync --args source target',
    'scp --args source target'
  ]
  p c
  p File.which_command(c)
end
