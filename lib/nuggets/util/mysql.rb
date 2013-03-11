#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2013 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# ruby-nuggets is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.        #
#                                                                             #
###############################################################################
#++

module Util

  module MySQL

    class Parser

      DEFAULT_NAME  = '__DEFAULT__'
      DEFAULT_TABLE = '__DEFAULT__'

      USE_RE           = /\AUSE\s+`(.+?)`/i
      CREATE_TABLE_RE  = /\ACREATE\s+TABLE\s+`(.+?)`/i
      TABLE_COLUMN_RE  = /\A\s+`(.+?)`/
      FINISH_TABLE_RE  = /\A\).*;\Z/
      INSERT_VALUES_RE = /\AINSERT\s+INTO\s+`(.+?)`\s+(?:\((.+?)\)\s+)?VALUES\s*(.*);\Z/i
      CLEAN_COLUMNS_RE = /[\s`]+/

      def self.parse(input, &block)
        parser = new.parse(input, &block)
        block_given? ? parser : parser.tables
      end

      def initialize
        reset
      end

      def reset
        @name         = DEFAULT_NAME
        @table        = DEFAULT_TABLE
        @tables       = {}
        @columns      = Hash.new { |h, k| h[k] = [] }
        @value_parser = ValueParser.new
      end

      attr_reader :tables

      def parse(input, &block)
        unless block
          tables, block = @tables, lambda { |_, name, table, columns, values|
            ((tables[name] ||= {})[table] ||= []) << fields = {}

            values.each_with_index { |value, index|
              if column = columns[index]
                fields[column] = value
              end
            }
          }
        end

        name, table, columns, value_parser, block_given =
          @name, @table, @columns, @value_parser, block_given?

        input.each { |line|
          case line
            when USE_RE
              name = $1
              yield :use, name if block_given
            when CREATE_TABLE_RE
              table = $1
            when TABLE_COLUMN_RE
              columns[table] << $1 if table
            when FINISH_TABLE_RE
              yield :table, name, table, columns[table] if block_given
              table = nil
            when INSERT_VALUES_RE
              _table, _columns, _values = $1, $2, $3

              _columns = _columns.nil? ? columns[_table] :
                _columns.gsub(CLEAN_COLUMNS_RE, '').split(',')

              value_parser.parse(_values) { |values|
                block[:insert, name, _table, _columns, values]
              } unless _columns.empty?
          end
        }

        @name, @table = name, table

        self
      end

    end

    class ValueParser

      AST = Struct.new(:value)

      def self.parse(input)
        new.parse(input)
      end

      def parse(input)
        @input = StringScanner.new(input)

        rows, block_given = [], block_given?

        while result = parse_row
          row = result.value
          block_given ? yield(row) : rows << row
          break unless @input.scan(/,\s*/)
        end

        @input.scan(/;/)  # optional

        error('Unexpected data') unless @input.eos?

        rows unless block_given
      end

      def parse_row
        return unless @input.scan(/\(/)

        row = []

        while result = parse_value
          row << result.value
          break unless @input.scan(/,\s*/)
        end

        error('Unclosed row') unless @input.scan(/\)/)

        AST.new(row)
      end

      def parse_value
        parse_string ||
        parse_number ||
        parse_keyword
      end

      def parse_string
        return unless @input.scan(/'/)

        string = ''

        while contents = parse_string_content || parse_string_escape
          string << contents.value
        end

        error('Unclosed string') unless @input.scan(/'/)

        AST.new(string)
      end

      def parse_string_content
        if @input.scan(/[^\\']+/)
          AST.new(@input.matched)
        end
      end

      def parse_string_escape
        if @input.scan(/\\[abtnvfr]/)
          AST.new(eval(%Q{"#{@input.matched}"}))
        elsif @input.scan(/\\.|''/)
          AST.new(@input.matched[-1, 1])
        end
      end

      def parse_number
        if @input.scan(/-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/)
          AST.new(eval(@input.matched))
        end
      end

      def parse_keyword
        if @input.scan(/null/i)
          AST.new(nil)
        end
      end

      def error(message)
        if @input.eos?
          raise "Unexpected end of input (#{message})."
        else
          raise "#{message} at #{$.}:#{@input.pos}: #{@input.peek(16).inspect}"
        end
      end

    end

  end

end
