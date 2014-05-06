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

module Nuggets
  module Env
    module UserHomeMixin

  # call-seq:
  #   ENV.user_home([default]) => aString
  #
  # Returns the user's home directory, or +default+ if it could not be found.
  def user_home(default = ::File::ALT_SEPARATOR ? 'C:/' : '/')
    begin
      return ::Dir.home
    rescue ::ArgumentError
      # "couldn't find HOME environment -- expanding `~'"
    end if ::Dir.respond_to?(:home)

    %w[HOME HOMEDRIVE:HOMEPATH USERPROFILE APPDATA].each { |key|
      home = values_at(*key.split(':')).join
      return home.gsub(/\\/, '/') if home && !home.empty?
    }

    begin
      ::File.expand_path('~')
    rescue ::ArgumentError
      default
    end
  end

    end
  end
end
