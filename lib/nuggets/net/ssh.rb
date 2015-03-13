#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2015 Jens Wille                                          #
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

require 'net/ssh'

class Net::SSH::Connection::Session

  def exec_sudo(command, prompt = /password/, &block)
    block ||= lambda { |data| ask(data) { |q| q.echo = false } }

    open_channel { |ch|
      ch.request_pty

      ch.exec("sudo #{command}") { ch.on_data { |_, data|
        ch.send_data("#{block[data]}\n") if data =~ prompt
      } }

      ch.wait
    }
  end

end
