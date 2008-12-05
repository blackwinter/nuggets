#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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

require 'enumerator'

class String

  # call-seq:
  #   str.word_wrap(line_width) => new_str
  #
  # Word wrap a string not exceeding +line_width+. Based on the Ruby Facets
  # implementation, but preserves paragraphs. Thus
  # <tt>str == str.word_wrap(str.split("\n").map { |l| l.length }.max)</tt>.
  def word_wrap(line_width = 80, as_array = false)
    wrapped = []

    split(/(\n+)/).to_enum(:each_slice, 2).each { |paragraph, linebreaks|
      wrapped << paragraph.word_wrap_paragraph!(line_width) << linebreaks
    }

    wrapped = wrapped.join
    
    as_array ? wrapped.split("\n") : wrapped
  end

  # call-seq:
  #   str.word_wrap!(line_width) => str
  #
  # As with #word_wrap, but modifies the string in place.
  def word_wrap!(line_width = 80)
    replace word_wrap(line_width)
  end

  # call-seq:
  #   str.word_wrap_paragraph(line_width) => new_str
  #
  # Similar to #word_wrap, but assumes a single paragraph.
  def word_wrap_paragraph(line_width = 80)
    (_dup = dup).word_wrap_paragraph!(line_width) || _dup
  end

  # call-seq:
  #   str.word_wrap_paragraph!(line_width) => str
  #
  # Destructive version of #word_wrap_paragraph.
  def word_wrap_paragraph!(line_width = 80)
    gsub!(/(.{1,#{line_width}})(?:\s+|$)/, "\\1\n")
    sub!(/\n$/, '')

    self
  end

end

if $0 == __FILE__
  s = <<EOT
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam nulla arcu,
ullamcorper non, vulputate eget, elementum quis, sapien. Quisque consequat
porta enim. Phasellus porta libero et turpis. Ut felis.

Phasellus eget est a enim rutrum accumsan. Integer nec purus. Maecenas
facilisis urna sed arcu. Suspendisse potenti.


Vestibulum lacus metus, faucibus sit amet, mattis non, mollis sed, pede. Aenean
vitae sem nec sem euismod sollicitudin. Cras rhoncus.



Phasellus condimentum, ante a cursus dictum, lectus ipsum convallis magna, sed
tincidunt massa eros vitae ante. Suspendisse nec sem.
In hac habitasse platea dictumst. Fusce purus leo, ullamcorper sit amet, luctus
in, mollis mollis, enim. In adipiscing erat.
EOT
  puts s

  puts '=' * 80

  puts s.word_wrap(60)
  puts '=' * 80
  puts s.word_wrap(79)

  puts '=' * 80

  s.word_wrap!(60)
  puts s
end
