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

class Numeric

  # call-seq:
  #   num.hms => anArray
  #
  # Converts _num_ into hour, minute, and second portions.
  def hms
    raise ::ArgumentError, "negative duration #{self}" if self < 0

    one_minute = 60
    one_hour   = 60 * one_minute

    [((h,) = divmod(one_hour)).last.divmod(one_minute), h].reverse.flatten  # *SCNR* ;-)
  end

  # call-seq:
  #   num.ymd => anArray
  #
  # Converts _num_ into year, month, and day portions.
  def ymd
    raise ::ArgumentError, "negative duration #{self}" if self < 0

    one_day   = 24 * 60 * 60
    one_month = 30 * one_day
    one_year  = 365.25 * one_day

    y, m = divmod(one_year)
    m, d = m.divmod(one_month)

    [y, m, d / one_day]
  end

  # call-seq:
  #   num.to_hms([precision[, labels]]) => aString
  #
  # Produces a stringified version of _num_'s time portions (cf. #hms),
  # with the specified +precision+ for the seconds (treated as floating
  # point). The individual parts are labelled as specified in the +labels+
  # parameter (hours, minutes, seconds in that order). Leading parts with
  # a value of zero are omitted.
  #
  # Examples:
  #   180.to_hms               #=> "3m0s"
  #   180.75.to_hms            #=> "3m1s"
  #   180.75.to_hms(2)         #=> "3m0.75s"
  #   8180.to_hms              #=> "2h16m20s"
  #   8180.to_hms(0, %w[: :])  #=> "2:16:20"
  def to_hms(precision = 0, labels = %w[h m s], time = hms)
    h, m, s = time

    h.zero? ? m.zero? ?
      "%0.#{precision}f#{labels[2]}" % [s] :
      "%d#{labels[1]}%0.#{precision}f#{labels[2]}" % [m, s] :
      "%d#{labels[0]}%d#{labels[1]}%0.#{precision}f#{labels[2]}" % [h, m, s]
  end

  # call-seq:
  #   num.to_ymd([include_hms[, labels]]) => aString
  #
  # Produces a stringified version of _num_'s date portions (cf. #ymd),
  # analogous to #to_hms. Includes time portions (cf. #hms) if +include_hms+
  # is +true+.
  def to_ymd(include_hms = false, labels = %w[y m d])
    unless include_hms
      to_hms(0, labels, ymd)
    else
      y, m, d = ymd
      e = d.truncate

      "#{to_hms(0, labels, [y, m, e])} #{((d - e) * 24 * 60 * 60).to_hms}"
    end
  end

end
