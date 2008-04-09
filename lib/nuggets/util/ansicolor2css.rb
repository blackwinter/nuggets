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

module Util

  module ANSIColor2CSS

    extend self

    COLOUR_RE = %r{\e\[((?:[0-9]|[34][0-7])(?:;(?:[0-9]|[34][0-7]))*)m}

    OPEN  = '<span style="'.freeze
    OPENC = '">'.freeze
    CLOSE = '</span>'.freeze

    ATTRIBUTES = {
       '0' => CLOSE,                            # clear
       '1' => 'font-weight: bold',              # bold
       '2' => '',                               # dark
       '3' => 'font-style: italic',             # italic -- not widely implemented
       '4' => 'text-decoration: underline',     # underline
       '5' => 'text-decoration: blink',         # blink
       '6' => 'text-decoration: blink',         # rapid blink -- not widely implemented
       '7' => '',                               # negative
       '8' => '',                               # concealed
       '9' => 'text-decoration: line-through',  # strikethrough -- not widely implemented
      '30' => 'color: black',                   # black
      '31' => 'color: red',                     # red
      '32' => 'color: green',                   # green
      '33' => 'color: yellow',                  # yellow
      '34' => 'color: blue',                    # blue
      '35' => 'color: magenta',                 # magenta
      '36' => 'color: cyan',                    # cyan
      '37' => 'color: white',                   # white
      '40' => 'background-color: black',        # on black
      '41' => 'background-color: red',          # on red
      '42' => 'background-color: green',        # on green
      '43' => 'background-color: yellow',       # on yellow
      '44' => 'background-color: blue',         # on blue
      '45' => 'background-color: magenta',      # on magenta
      '46' => 'background-color: cyan',         # on cyan
      '47' => 'background-color: white'         # on white
    }

    def convert(string)
      string.gsub(COLOUR_RE) {
        subst, attrs = '', $1.split(';')

        subst << CLOSE if attrs.delete('0')
        subst << OPEN << attrs.map { |c| ATTRIBUTES[c] }.join('; ') << OPENC unless attrs.empty?

        subst
      }
    end

  end

end

class String

  def ansicolor2css
    Util::ANSIColor2CSS.convert(self)
  end

end
