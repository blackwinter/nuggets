#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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
    module CamelscoreMixin

  # List of acronyms to treat specially
  # in #camelcase and #underscore.
  CAMELSCORE_ACRONYMS = {
    'html' => 'HTML',
    'rss'  => 'RSS',
    'sql'  => 'SQL',
    'ssl'  => 'SSL',
    'xml'  => 'XML'
  }

  # call-seq:
  #   str.camelcase => new_string
  #
  # Returns the CamelCase form of _str_.
  def camelcase
    dup.camelcase!
  end

  alias_method :camelize, :camelcase

  # call-seq:
  #   str.camelcase! => str
  #
  # Replaces _str_ with its CamelCase form and returns _str_.
  def camelcase!
    sub!(/^[a-z]+/) {
      CAMELSCORE_ACRONYMS[$&] || $&.capitalize
    }

    gsub!(/(?:_|([\/\d]))([a-z]+)/i) {
      "#{$1}#{CAMELSCORE_ACRONYMS[$2] || $2.capitalize}"
    }

    gsub!('/', '::')

    self
  end

  alias_method :camelize!, :camelcase!

  # call-seq:
  #   str.underscore => new_string
  #
  # Returns the under_score form of _str_.
  def underscore
    dup.underscore!
  end

  # call-seq:
  #   str.underscore! => str
  #
  # Replaces _str_ with its under_score form and returns _str_.
  def underscore!
    gsub!(/::/, '/')

    a = CAMELSCORE_ACRONYMS.values
    r = a.empty? ? /(?=a)b/ : ::Regexp.union(*a.sort_by { |v| v.length })

    gsub!(/(?:([A-Za-z])|(\d)|^)(#{r})(?=\b|[^a-z])/) {
      "#{$1 || $2}#{'_' if $1}#{$3.downcase}"
    }

    gsub!(/([A-Z])(?=[A-Z])/, '\1_')
    gsub!(/([a-z\d])([A-Z])/, '\1_\2')

    downcase!

    self
  end

  # call-seq:
  #   str.constantize(base = Object) => anObject
  #
  # Returns the constant pointed to by _str_, relative to +base+.
  def constantize(base = ::Object)
    names = split('::')
    return if names.empty?

    const = names.first.empty? ? (names.shift; ::Object) : base
    names.each { |name| const = const.const_get(name) }
    const
  end

    end
  end
end
