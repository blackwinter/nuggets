#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2008-2009 Jens Wille                                          #
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
  module Env
    module UserHomeMixin

  # call-seq:
  #   ENV.user_home => aString
  #
  # Finds the user's home directory. Stolen from RubyGems ;-)
  def user_home(default = ::File::ALT_SEPARATOR ? 'C:/' : '/')
    %w[HOME USERPROFILE].each { |homekey|
      home = self[homekey]
      return home if home
    }

    if drive = self['HOMEDRIVE'] and path = self['HOMEPATH']
      return "#{drive}:#{path}"
    end

    begin
      ::File.expand_path('~')
    rescue ArgumentError
      default
    end
  end

    end
  end
end
