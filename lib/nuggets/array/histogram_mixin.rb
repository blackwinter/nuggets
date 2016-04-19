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
  class Array
    module HistogramMixin

  # Provides some default formats for #formatted_histogram.
  #
  # Example:
  #
  #   (default)         ab  [==]  2
  #   (percent)         xyz [===] 3 (37.50%)
  #   (numeric)          42 [==]  2
  #   (numeric_percent) 123 [=]   1 (12.50%)
  #
  # The "numeric" variants format the item as a (decimal) number.
  FORMATS = {
    default:         '%-*s [%s]%*s %*d',
    percent:         '%-*s [%s]%*s %*d (%.2f%%)',
    numeric:          '%*d [%s]%*s %*d',
    numeric_percent:  '%*d [%s]%*s %*d (%.2f%%)'
  }

  # Encapsulates a #histogram item and provides the following attributes (see
  # also #annotated_histogram):
  #
  # item::            The original item
  # freq::            The item's frequency in the collection
  # percentage::      The percentage of the item's frequency in the collection
  # max_freq::        The maximum frequency in the collection
  # max_freq_length:: The maximum frequency's "width"
  # max_item_length:: The maximum item length in the collection
  HistogramItem = ::Struct.new(
    :item, :freq, :max_freq, :max_freq_length, :max_item_length, :percentage
  )

  # call-seq:
  #   array.histogram => aHash
  #   array.histogram { |x| ... } => aHash
  #
  # Calculates the {frequency histogram}[http://en.wikipedia.org/wiki/Histogram]
  # of the values in _array_. Returns a Hash that maps any value, or the result
  # of the value yielded to the block, to its frequency.
  def histogram
    hist = ::Hash.new(0)
    each { |x| hist[block_given? ? yield(x) : x] += 1 }
    hist
  end

  # call-seq:
  #   array.probability_mass_function => aHash
  #   array.probability_mass_function { |x| ... } => aHash
  #
  # Calculates the {probability mass function}[http://en.wikipedia.org/wiki/Probability_mass_function]
  # (normalized histogram) of the values in _array_. Returns a Hash that
  # maps any value, or the result of the value yielded to the block, to
  # its probability (via #histogram).
  def probability_mass_function(&block)
    hist, n = histogram(&block), size.to_f
    hist.each { |k, v| hist[k] = v / n }
  end

  alias_method :pmf, :probability_mass_function

  # call-seq:
  #   array.annotated_histogram => anArray
  #   array.annotated_histogram { |hist_item| ... } => aHash
  #
  # Calculates the #histogram for _array_ and yields each histogram item
  # (see HistogramItem) to the block or returns an Array of the histogram
  # items.
  def annotated_histogram
    hist, items = histogram, []

    percentage = size / 100.0

    max_freq = hist.values.max
    max_freq_length = max_freq.to_s.length

    max_item_length = hist.keys.map { |item| item.to_s.length }.max

    # try to sort the histogram hash
    begin
      hist = hist.sort
    rescue ::ArgumentError
    end

    hist.each { |item, freq|
      hist_item = HistogramItem.new(
        item, freq, max_freq, max_freq_length, max_item_length, freq / percentage
      )

      block_given? ? yield(hist_item) : items << hist_item
    }

    block_given? ? hist : items
  end

  # call-seq:
  #   array.formatted_histogram([format[, indicator]]) => aString
  #
  # Returns the #histogram of _array_ as a formatted String according to
  # +format+, using +indicator+ to draw the frequency bar.
  #
  # +format+ may be a Symbol indicating one of the provided default formats
  # (see FORMATS) or a format String (see Kernel#sprintf) that will receive
  # the following arguments (in order):
  #
  # 1. +max_item_length+ (Integer)
  # 1. +item+ (String)
  # 1. "frequency_bar" (String)
  # 1. "padding" (String)
  # 1. +max_freq_length+ (Integer)
  # 1. +freq+ (Integer)
  # 1. +percentage+ (Float, optional)
  #
  # See HistogramItem for further details on the individual arguments.
  def formatted_histogram(format = :default, indicator = '=')
    format = FORMATS[format] if FORMATS.key?(format)
    raise ::TypeError, "String expected, got #{format.class}" unless format.is_a?(::String)

    include_percentage = format.include?('%%')
    indicator_length   = indicator.length

    lines = []

    annotated_histogram { |hist|
      arguments = [
        hist.max_item_length, hist.item,                     # item (padded)
        indicator * hist.freq,                               # indicator bar
        (hist.max_freq - hist.freq) * indicator_length, '',  # indicator padding
        hist.max_freq_length, hist.freq                      # frequency (padded)
      ]

      arguments << hist.percentage if include_percentage     # percentage (optional)

      lines << format % arguments
    }

    lines.join("\n")
  end

    end
  end
end
