# encoding: utf-8

#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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
    class Reader < Base

  DEFAULT_IO = $stdin

  class << self

    def parse(*args, &block)
      reader = new(extract_options!(args)).parse(*args, &block)
      block ? reader : reader.records
    end

    def parse_file(*args, &block)
      file_method(:parse, 'r', *args, &block)
    end

  end

  attr_reader :records

  def reset
    super
    @records = {}
  end

  def vs=(vs)
    @vs = vs.is_a?(::Regexp) ? vs : %r{\s*#{::Regexp.escape(vs)}\s*}
  end

  def parse(io = io, &block)
    unless block
      records, block = @records, amend_block { |id, record|
        records[id] = record
      }
    end

    rs, fs, vs, nl, le, key, auto_id, id, record =
      @rs, @fs, @vs, @nl, @le, @key, @auto_id, nil, {}

    io.each { |line|
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

    r, i = block.binding.eval('_ = records, io')

    l = i.respond_to?(:lineno)
    s = i.respond_to?(:path) ? i.path :
      ::Object.instance_method(:inspect).bind(i).call

    lambda { |id, *args|
      if (r ||= block.binding.eval('records')).key?(id)
        warn "Duplicate record in #{s}#{":#{i.lineno}" if l}: »#{k}:#{id}«"
      end

      block[id, *args]
    }
  end

    end
  end
end
