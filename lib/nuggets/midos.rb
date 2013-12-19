# encoding: utf-8

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

module Nuggets
  module Midos

    # Record separator
    DEFAULT_RS = '&&&'

    # Field separator
    DEFAULT_FS = ':'

    # Value separator
    DEFAULT_VS = '|'

    # Line break indicator
    DEFAULT_NL = '^'

    # Line ending
    DEFAULT_LE = "\r\n"

    # Default file encoding
    DEFAULT_ENCODING = 'iso-8859-1'

    class << self

      def filter(source, target, source_options = {}, target_options = source_options)
        records = {}

        Parser.parse(source, source_options) { |id, record|
          records[id] = record if yield(id, record)
        }

        Writer.write(target, records, target_options)

        records
      end

      def filter_file(source_file, target_file, source_options = {}, target_options = source_options, &block)
        source_options[:encoding] ||= DEFAULT_ENCODING
        target_options[:encoding] ||= DEFAULT_ENCODING

        ::File.open(source_file, :encoding => source_options[:encoding]) { |source|
          ::File.open(target_file, 'w', :encoding => target_options[:encoding]) { |target|
            filter(source, target, source_options, target_options, &block)
          }
        }
      end

      def convert(*args)
        filter(*args) { |*| true }
      end

      def convert_file(*args)
        filter_file(*args) { |*| true }
      end

    end

    class Base

      def initialize(options = {}, &block)
        self.key = options[:key]

        self.rs = options[:rs] || DEFAULT_RS
        self.fs = options[:fs] || DEFAULT_FS
        self.vs = options[:vs] || DEFAULT_VS
        self.nl = options[:nl] || DEFAULT_NL
        self.le = options[:le] || DEFAULT_LE

        @auto_id_block = block
        reset
      end

      attr_accessor :key, :rs, :fs, :nl, :le, :auto_id

      attr_reader :vs, :records

      def vs=(vs)
        @vs = vs.is_a?(::Regexp) ? vs : %r{\s*#{::Regexp.escape(vs)}\s*}
      end

      def reset
        @records = {}
        @auto_id = @auto_id_block ? @auto_id_block.call : default_auto_id
      end

      private

      def default_auto_id(n = 0)
        lambda { n += 1 }
      end

    end

    class Parser < Base

      class << self

        def parse(source, options = {}, &block)
          parser = new(options).parse(source, &block)
          block_given? ? parser : parser.records
        end

        def parse_file(file, options = {}, &block)
          ::File.open(file, :encoding => options[:encoding] ||= DEFAULT_ENCODING) { |source|
            parse(source, options, &block)
          }
        end

      end

      def initialize(options = {})
        super
        @vs = /\s*#{::Regexp.escape(@vs)}\s*/ unless @vs.is_a?(::Regexp)
      end

      def parse(source, &block)
        unless block
          records, block = @records, amend_block { |id, record|
            records[id] = record
          }
        end

        rs, fs, vs, nl, le, key, auto_id, id, record =
          @rs, @fs, @vs, @nl, @le, @key, @auto_id, nil, {}

        source.each { |line|
          line = line.chomp(le)

          if line == rs
            block[key ? id : auto_id.call, record]
            id, record = nil, {}
          else
            k, v = line.split(fs, 2)

            if k && v
              if k == key
                id = v
              else
                v.gsub!(nl, "\n")
                v = v.split(vs) if v.index(vs)
              end

              record[k] = v
            end
          end
        }

        self
      end

      private

      def amend_block(&block)
        return block unless $VERBOSE && k = @key

        r, i = block.binding.eval('_ = records, source')

        l = i.respond_to?(:lineno)
        s = i.respond_to?(:path) ? i.path :
          ::Object.instance_method(:inspect).bind(i).call

        lambda { |id, *args|
          if (r ||= block.binding.eval('records')).has_key?(id)
            warn "Duplicate record in #{s}#{":#{i.lineno}" if l}: »#{k}:#{id}«"
          end

          block[id, *args]
        }
      end

    end

    class Writer < Base

      class << self

        def write(target, records, options = {})
          new(options).write(target, records)
        end

        def write_file(file, records, options = {})
          ::File.open(file, 'w', :encoding => options[:encoding] ||= DEFAULT_ENCODING) { |target|
            write(target, records, options)
          }
        end

      end

      def write(target, records = {})
        rs, fs, vs, nl, le, key, auto_id =
          @rs, @fs, @vs, @nl, @le, @key, @auto_id

        @records.update(records).each { |id, record|
          record, id = id, nil unless record

          if key && !record.has_key?(key)
            record[key] = id || auto_id.call
          end

          record.each { |k, v|
            if v
              v = v.is_a?(::Array) ? v.join(vs) : v.to_s
              target << k << fs << v.gsub("\n", nl) << le
            end
          }

          target << rs << le << le
        }

        self
      end

    end

  end
end
