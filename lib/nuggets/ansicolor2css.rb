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
  module ANSIColor2CSS

    extend self

    ATTRIBUTES = {
        '0' => nil,                              # clear
        '1' => 'font-weight: bold',              # bold
        '2' => '',                               # dark
        '3' => 'font-style: italic',             # italic -- not widely implemented
        '4' => 'text-decoration: underline',     # underline
        '5' => 'text-decoration: blink',         # blink
        '6' => 'text-decoration: blink',         # rapid blink -- not widely implemented
        '7' => '',                               # reverse
        '8' => 'opacity: 0',                     # concealed
        '9' => 'text-decoration: line-through',  # strikethrough -- not widely implemented
       '22' => 'font-weight: normal',            # bold off
       '23' => 'font-style: normal',             # italic off
       '24' => 'text-decoration: none',          # underline off
       '25' => 'text-decoration: none',          # blink off
       '27' => '',                               # reverse off
       '28' => 'opacity: 1',                     # concealed off
       '29' => 'text-decoration: none',          # strikethrough off
       '30' => 'color: black',                   # black
       '31' => 'color: maroon',                  # red
       '32' => 'color: green',                   # green
       '33' => 'color: olive',                   # yellow
       '34' => 'color: navy',                    # blue
       '35' => 'color: purple',                  # magenta
       '36' => 'color: teal',                    # cyan
       '37' => 'color: silver',                  # white
       '39' => 'color: silver',                  # default (white)
       '40' => 'background-color: black',        # on black
       '41' => 'background-color: maroon',       # on red
       '42' => 'background-color: green',        # on green
       '43' => 'background-color: olive',        # on yellow
       '44' => 'background-color: navy',         # on blue
       '45' => 'background-color: purple',       # on magenta
       '46' => 'background-color: teal',         # on cyan
       '47' => 'background-color: silver',       # on white
       '49' => 'background-color: black',        # on default (black)
       '90' => 'color: gray',                    # bright black
       '91' => 'color: red',                     # bright red
       '92' => 'color: lime',                    # bright green
       '93' => 'color: yellow',                  # bright yellow
       '94' => 'color: blue',                    # bright blue
       '95' => 'color: fuchsia',                 # bright magenta
       '96' => 'color: cyan',                    # bright cyan
       '97' => 'color: white',                   # bright white
      '100' => 'background-color: gray',         # on bright black
      '101' => 'background-color: red',          # on bright red
      '102' => 'background-color: lime',         # on bright green
      '103' => 'background-color: yellow',       # on bright yellow
      '104' => 'background-color: blue',         # on bright blue
      '105' => 'background-color: fuchsia',      # on bright magenta
      '106' => 'background-color: cyan',         # on bright cyan
      '107' => 'background-color: white'         # on bright white
    }

    ATTRIBUTES_RE = ::Regexp.union(*ATTRIBUTES.keys)

    DELIMITER = ';'

    COLOR_RE = %r{
      \e \[ ( #{ATTRIBUTES_RE} (?: #{DELIMITER} #{ATTRIBUTES_RE} )* ) m
    }x

    STYLE = '<span style="%s">'
    CLEAR = '</span>'

    def convert(string)
      string.gsub(COLOR_RE) { format($1.split(DELIMITER).uniq) }
    end

    def format(attributes)
      "#{clear(attributes)}#{style(attributes) if attributes.any?}"
    end

    def clear(attributes)
      CLEAR if attributes.delete('0')
    end

    def style(attributes)
      STYLE % ATTRIBUTES.values_at(*attributes).join('; ')
    end

  end
end

class String

  def ansicolor2css
    ::Nuggets::ANSIColor2CSS.convert(self)
  end

  alias_method :ansicolour2css, :ansicolor2css

end
