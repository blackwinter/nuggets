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
  class String
    module WcMixin

  # call-seq:
  #   str.wc => anArray
  #
  # Count number of lines, words, and bytes in _str_.
  def wc
    [wc_l, wc_w, wc_c]
  end

  # call-seq:
  #   str.line_count => anInteger
  #
  # Count number of lines in _str_.
  def line_count
    count_by_re(/#{$/}/)
  end
  alias_method :wc_l, :line_count

  # call-seq:
  #   str.word_count => anInteger
  #
  # Count number of words in _str_.
  def word_count
    count_by_re(/\S+/)
  end
  alias_method :wc_w, :word_count

  # call-seq:
  #   str.byte_count => anInteger
  #
  # Count number of bytes in _str_.
  def byte_count
    respond_to?(:bytesize) ? bytesize : count_by_re(//n) - 1
  end
  alias_method :wc_c, :byte_count

  # call-seq:
  #   str.char_count => anInteger
  #
  # Count number of characters in _str_.
  def char_count
    count_by_re(/./um)
  end
  alias_method :wc_m, :char_count

  # call-seq:
  #   str.count_by_re(re) => anInteger
  #
  # Count number of occurrences of +re+ in _str_.
  def count_by_re(re)
    scan(re).size
  end

  # call-seq:
  #   str.count_by_re2(re) => anInteger
  #
  # A more memory-efficient version of #count_by_re.
  def count_by_re2(re)
    count = 0
    scan(re) { |_| count += 1 }
    count
  end

    end
  end
end
