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

require 'nuggets/log_parser'

module Nuggets
  module LogParser
    module Apache

      extend self

      DEFAULT_RE = %r{(.*?)}

      DIRECTIVES = {
        'h' => [:ip,        %r{(\d+(?:\.\d+){3}|[\w.-]+)}],
        'l' => [:auth,      DEFAULT_RE],
        'u' => [:username,  DEFAULT_RE],
        't' => [:datetime,  %r{\[(.*?)\]}],
        'r' => [:request,   DEFAULT_RE],
        'R' => [:request,   %r{(.*?)(?:"|\z)}],
        's' => [:status,    %r{(\d+)}],
        'b' => [:bytecount, %r{(-|\d+)}],
        'v' => [:domain,    DEFAULT_RE],
        'i' => [nil,        DEFAULT_RE],
      }

      DIRECTIVES_RE = %r{%.*?(?:\{(.*?)\})?([#{DIRECTIVES.keys.join}])([\s\\"]*)}

      ORDER = []

      class << self

        def register(name, format)
          base = const_set(name, Module.new)

          re, items = parse_format(format)
          base.const_set(:RE,    re)
          base.const_set(:ITEMS, items)

          ORDER << base
          LogParser.register(base, self)
        end

        def parse_format(format)
          re, items = '\A', []

          format.scan(DIRECTIVES_RE) { |h, c, e|
            i, r = DIRECTIVES[c]
            re << r.source << e.gsub(/\s/, '\\s')
            items << i ||= h.downcase.tr('-', '_').to_sym
          }

          [Regexp.new(re), items]
        end

        def detect_type(line)
          ORDER.find { |type| line =~ type::RE }
        end

      end

      [ [:Combined, '%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-agent}i"'],
        [:Common,   '%h %l %u %t "%r" %>s %b'],
        [:Minimal,  '%h %l %u %t "%R']
      ].each { |name, format| register(name, format) }

      def parse_line(line, entry = {})
        if md = self::RE.match(line)
          self::ITEMS.each_with_index { |k, i| entry[k] = md[i + 1] }
          yield if block_given?
        end

        entry
      end

    end
  end
end
