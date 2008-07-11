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

class Object

  # call-seq:
  #   object.msend(*messages) => anArray
  #
  # Sends _object_ multiple +messages+ and returns an array of the individual
  # return values.
  def msend(*messages)
    messages_with_args = messages.last.is_a?(Hash) ? messages.pop : {}

    (messages + messages_with_args.keys).map { |msg|
      messages_with_args.has_key?(msg) ? send(msg, *messages_with_args[msg]) : send(msg)
    }
  end

end

if $0 == __FILE__
  o = 'foo bar'
  p o
  p o.msend(:length, :reverse)

  o = 42
  p o
  p o.msend(:to_s, :* => 2)

  o = Time.now
  p o
  p o.msend(:year, :month, :day)
end
