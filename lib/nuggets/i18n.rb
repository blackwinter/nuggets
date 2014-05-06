# encoding: utf-8

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
  module I18n

    DIACRITICS = {
      'À' => 'A',  # LATIN CAPITAL LETTER A WITH GRAVE
      'Á' => 'A',  # LATIN CAPITAL LETTER A WITH ACUTE
      'Â' => 'A',  # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
      'Ã' => 'A',  # LATIN CAPITAL LETTER A WITH TILDE
      'Ä' => 'AE', # LATIN CAPITAL LETTER A WITH DIAERESIS
      'Å' => 'A',  # LATIN CAPITAL LETTER A WITH RING ABOVE
      'Æ' => 'AE', # LATIN CAPITAL LETTER AE
      'Ç' => 'C',  # LATIN CAPITAL LETTER C WITH CEDILLA
      'È' => 'E',  # LATIN CAPITAL LETTER E WITH GRAVE
      'É' => 'E',  # LATIN CAPITAL LETTER E WITH ACUTE
      'Ê' => 'E',  # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
      'Ë' => 'E',  # LATIN CAPITAL LETTER E WITH DIAERESIS
      'Ì' => 'I',  # LATIN CAPITAL LETTER I WITH GRAVE
      'Í' => 'I',  # LATIN CAPITAL LETTER I WITH ACUTE
      'Î' => 'I',  # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
      'Ï' => 'I',  # LATIN CAPITAL LETTER I WITH DIAERESIS
      'Ð' => 'DH', # LATIN CAPITAL LETTER ETH
      'Ñ' => 'N',  # LATIN CAPITAL LETTER N WITH TILDE
      'Ò' => 'O',  # LATIN CAPITAL LETTER O WITH GRAVE
      'Ó' => 'O',  # LATIN CAPITAL LETTER O WITH ACUTE
      'Ô' => 'O',  # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
      'Õ' => 'O',  # LATIN CAPITAL LETTER O WITH TILDE
      'Ö' => 'OE', # LATIN CAPITAL LETTER O WITH DIAERESIS
      'Ø' => 'O',  # LATIN CAPITAL LETTER O WITH STROKE
      'Ù' => 'U',  # LATIN CAPITAL LETTER U WITH GRAVE
      'Ú' => 'U',  # LATIN CAPITAL LETTER U WITH ACUTE
      'Û' => 'U',  # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
      'Ü' => 'UE', # LATIN CAPITAL LETTER U WITH DIAERESIS
      'Ý' => 'Y',  # LATIN CAPITAL LETTER Y WITH ACUTE
      'Þ' => 'TH', # LATIN CAPITAL LETTER THORN
      'ß' => 'ss', # LATIN SMALL LETTER SHARP S
      'à' => 'a',  # LATIN SMALL LETTER A WITH GRAVE
      'á' => 'a',  # LATIN SMALL LETTER A WITH ACUTE
      'â' => 'a',  # LATIN SMALL LETTER A WITH CIRCUMFLEX
      'ã' => 'a',  # LATIN SMALL LETTER A WITH TILDE
      'ä' => 'ae', # LATIN SMALL LETTER A WITH DIAERESIS
      'å' => 'a',  # LATIN SMALL LETTER A WITH RING ABOVE
      'æ' => 'ae', # LATIN SMALL LETTER AE
      'ç' => 'c',  # LATIN SMALL LETTER C WITH CEDILLA
      'è' => 'e',  # LATIN SMALL LETTER E WITH GRAVE
      'é' => 'e',  # LATIN SMALL LETTER E WITH ACUTE
      'ê' => 'e',  # LATIN SMALL LETTER E WITH CIRCUMFLEX
      'ë' => 'e',  # LATIN SMALL LETTER E WITH DIAERESIS
      'ì' => 'i',  # LATIN SMALL LETTER I WITH GRAVE
      'í' => 'i',  # LATIN SMALL LETTER I WITH ACUTE
      'î' => 'i',  # LATIN SMALL LETTER I WITH CIRCUMFLEX
      'ï' => 'i',  # LATIN SMALL LETTER I WITH DIAERESIS
      'ð' => 'dh', # LATIN SMALL LETTER ETH
      'ñ' => 'n',  # LATIN SMALL LETTER N WITH TILDE
      'ò' => 'o',  # LATIN SMALL LETTER O WITH GRAVE
      'ó' => 'o',  # LATIN SMALL LETTER O WITH ACUTE
      'ô' => 'o',  # LATIN SMALL LETTER O WITH CIRCUMFLEX
      'õ' => 'o',  # LATIN SMALL LETTER O WITH TILDE
      'ö' => 'oe', # LATIN SMALL LETTER O WITH DIAERESIS
      'ø' => 'o',  # LATIN SMALL LETTER O WITH STROKE
      'ù' => 'u',  # LATIN SMALL LETTER U WITH GRAVE
      'ú' => 'u',  # LATIN SMALL LETTER U WITH ACUTE
      'û' => 'u',  # LATIN SMALL LETTER U WITH CIRCUMFLEX
      'ü' => 'ue', # LATIN SMALL LETTER U WITH DIAERESIS
      'ý' => 'y',  # LATIN SMALL LETTER Y WITH ACUTE
      'þ' => 'th', # LATIN SMALL LETTER THORN
      'ÿ' => 'y'   # LATIN SMALL LETTER Y WITH DIAERESIS
    }

    def self.args_for_map_diacritics
      @args_for_map_diacritics ||= begin
        map = ::Hash.new { |h, k| h[k] = [] }

        DIACRITICS.each { |a| a.each { |i| map[i].concat(a) } }
        map.each { |k, v| v.uniq!; map[k] = "(#{::Regexp.union(*v).source})" }

        [::Regexp.union(*map.keys.sort_by { |k| -k.length }), map.method(:[])]
      end
    end

  end
end

class String

  # call-seq:
  #   str.replace_diacritics => new_str
  #
  # Substitutes any diacritics in _str_ with their replacements as per
  # Nuggets::I18n::DIACRITICS.
  def replace_diacritics
    (_dup = dup).replace_diacritics! || _dup
  end

  # call-seq:
  #   str.replace_diacritics! => str or +nil+
  #
  # Destructive version of #replace_diacritics.
  def replace_diacritics!
    diacritics = ::Nuggets::I18n::DIACRITICS

    gsub!(/#{::Regexp.union(*diacritics.keys)}/) { |m|
      s = diacritics[m]

      # Try to adjust case:
      #   'Äh' => 'AEh' => 'Aeh'
      #
      # But:
      #   'SÖS' => 'SOES' (not 'SOeS'!)
      if s.length > 1
        t = $'[0, 1]
        s[1..-1] = s[1..-1].downcase if t == t.downcase
      end

      s
    }
  end

  def map_diacritics
    (_dup = dup).map_diacritics! || _dup
  end

  def map_diacritics!
    re, block = ::Nuggets::I18n.args_for_map_diacritics
    gsub!(re, &block)
  end

end
