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

begin
  require 'win32console'
rescue ::LoadError
end

module Nuggets
  module Env
    module UserEncodingMixin

  # call-seq:
  #   ENV.user_encoding => aString
  #
  # Finds the user's selected encoding.
  def user_encoding(default = 'UTF-8')
    self['ENCODING'] || begin
      lang = self['LANG']
      lang[/\.(.*)/, 1] if lang
    end || if defined?(::Win32::Console)
      "CP#{::Win32::Console.InputCP}"
    elsif ::File::ALT_SEPARATOR
      cp = %x{chcp}[/:\s*(.*?)\./, 1]
      "CP#{cp}" if cp
    end || default
  end

    end
  end
end
