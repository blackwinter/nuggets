#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2008 Jens Wille                                               #
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

class << ENV

  # call-seq:
  #   ENV.user_encoding => aString or nil
  #
  # Finds the user's selected encoding.
  def user_encoding
    ENV['ENCODING']          ||
    ENV['LANG'][/\.(.*)/, 1] ||
    begin
      require 'win32console'
      "CP#{Win32::Console.InputCP}"
    rescue LoadError
      "CP#{%x{chcp}[/:\s*(.*?)\./, 1]}"
    end
  end

end

if $0 == __FILE__
  p ENV.user_encoding
end
