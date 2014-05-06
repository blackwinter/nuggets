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
    replace(word_wrap(line_width))
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
