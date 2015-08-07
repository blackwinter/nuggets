#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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

class Numeric

  def positive?
    self > 0
  end

  def negative?
    self < 0
  end

  def non_negative?
    !negative?
  end

  # call-seq:
  #   num.signum => -1, 0, 1
  #
  # Returns the sign of _num_.
  def signum
    # http://weblog.jamisbuck.org/2015/8/5/reducing-a-number-to-its-sign.html
    self <=> 0
  end

  alias_method :sign, :signum
  alias_method :sgn,  :signum

  def signum_s(positive = '+', negative = '-', zero = positive)
    [zero, positive, negative][signum]
  end

  alias_method :sign_s, :signum_s
  alias_method :sgn_s,  :signum_s

end
