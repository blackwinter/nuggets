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

  module Midos

    class Parser

      # Record separator
      DEFAULT_RS = '&&&'

      # Field separator
      DEFAULT_FS = ':'

      # Value separator
      DEFAULT_VS = ' | '

      def self.parse(input, *args, &block)
        parser = new(*args).parse(input, &block)
        block_given? ? parser : parser.records
      end

      def initialize(options = {})
        @key = options[:key]

        @rs = options[:rs] || DEFAULT_RS
        @fs = options[:fs] || DEFAULT_FS
        @vs = options[:vs] || DEFAULT_VS
        @vs = /\s*#{Regexp.escape(@vs)}\s*/ unless @vs.is_a?(Regexp)

        reset
      end

      attr_reader :rs, :fs, :vs, :key, :records

      def reset
        @records = {}
        @auto_id = auto_id
      end

      def parse(input, &block)
        unless block
          records, block = @records, amend_block { |id, record|
            records[id] = record
          }
        end

        rs, fs, vs, key, auto_id, id, record =
          @rs, @fs, @vs, @key, @auto_id, nil, {}

        input.each { |line|
          line = line.chomp

          if line == rs
            block[key ? id : auto_id.call, record]
            id, record = nil, {}
          else
            k, v = line.split(fs, 2)

            if k && v
              if k == key
                id = v
              elsif v.index(vs)
                v = v.split(vs)
              end

              record[k] = v
            end
          end
        }

        self
      end

      private

      def auto_id(n = 0)
        lambda { n += 1 }
      end

      def amend_block(&block)
        return block unless $VERBOSE && k = @key

        r, i = block.binding.eval('_ = records, input')

        l = i.respond_to?(:lineno)
        s = i.respond_to?(:path) ? i.path : Object.instance_method(:inspect).bind(i).call

        lambda { |id, *args|
          if (r ||= block.binding.eval('records')).has_key?(id)
            warn "Duplicate record in #{s}#{":#{i.lineno}" if l}: »#{k}:#{id}«"
          end

          block[id, *args]
        }
      end

    end

  end

end
