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

module Nuggets
  class IO
    module InteractMixin

  # call-seq:
  #   IO.interact(input, output[, timeout[, maxlen]]) -> anArray | nil
  #
  # Interact with both ends of a pipe in a non-blocking manner.
  #
  # +input+ represents the sending end and is a mapping from the actual
  # input IO (to send into the pipe) to the pipe's input handle (_stdin_).
  # The input IO must support +read_nonblock+. If it's a StringIO it will
  # be extended appropriately. If it's a String it will be converted to
  # a StringIO.
  #
  # +output+ represents the receiving end and is a mapping from the pipe's
  # output handle (_stdout_) to the designated output IO (to receive data
  # from the pipe), and, optionally, from the pipe's error handle (_stderr_)
  # to the designated error IO. The output and error IO must support <tt><<</tt>
  # with a string argument. If either of them is a Proc it will be extended such
  # that <tt><<</tt> delegates to +call+.
  #
  # +timeout+, if given, will be passed to IO::select and +nil+ is returned
  # if the select call times out; in all other cases an empty array is returned.
  #
  # +maxlen+ is the chunk size for +read_nonblock+.
  #
  # Examples:
  #
  #   require 'open3'
  #
  #   # simply prints 'input string' on STDOUT, ignores +stderr+
  #   Open3.popen3('cat') { |stdin, stdout, stderr|
  #     IO.interact({ "input string\n" => stdin }, { stdout => STDOUT })
  #   }
  #
  #   # prints lines you type in reverse order to a string
  #   str = ''
  #   Open3.popen3('tac') { |stdin, stdout, stderr|
  #     IO.interact({ STDIN => stdin }, { stdout => str })
  #   }
  #   puts str
  #
  #   # prints the IP adresses from /etc/hosts on STDOUT and their lengths
  #   # on STDERR
  #   cmd = %q{ruby -ne 'i = $_.split.first or next; warn i.length; puts i'}
  #   Open3.popen3(cmd) { |stdin, stdout, stderr|
  #     File.open('/etc/hosts') { |f|
  #       IO.interact({ f => stdin }, { stdout => STDOUT, stderr => STDERR })
  #     }
  #   }
  def interact(input, output, timeout = nil, maxlen = nil)
    Interaction.new(input, output, timeout, maxlen).interact
  end

  class Interaction

    DEFAULT_MAXLEN = 2 ** 16

    def initialize(input, output, timeout = nil, maxlen = nil)
      @readers, @writers = {}, {}

      output.each { |key, val| @readers[key] =  initialize_reader(val)      }
      input.each  { |key, val| @writers[val] = [initialize_writer(key), ''] }

      @timeout, @maxlen = timeout, maxlen || DEFAULT_MAXLEN
    end

    attr_reader :readers, :writers

    attr_accessor :timeout, :maxlen

    def interact
      until readers.empty? && writers.empty?
        handles = select(readers.keys, writers.keys, nil, timeout) or return

        handle_readers(handles[0])
        handle_writers(handles[1])
      end

      []
    end

    private

    def initialize_reader(reader)
      if reader.is_a?(::Proc) && !reader.respond_to?(:<<)
        class << reader; alias_method :<<, :call; end
      end

      reader
    end

    def initialize_writer(writer)
      if writer.is_a?(::String)
        require 'stringio'
        writer = ::StringIO.new(writer)
      end

      unless writer.respond_to?(:read_nonblock)
        def writer.read_nonblock(*args)
          read(*args) or raise ::EOFError, 'end of string reached'
        end
      end

      writer
    end

    def handle_readers(handles)
      handles.each { |reader| read(reader, readers[reader]) }
    end

    def handle_writers(handles)
      handles.each { |writer|
        reader, buffer = writers[writer]
        read(reader, buffer, writer) or next if buffer.empty?

        begin
          bytes = writer.write_nonblock(buffer)
        rescue ::Errno::EPIPE
          close(writers, writer)
        end

        buffer.force_encoding('BINARY').slice!(0, bytes) if bytes
      }
    end

    def read(reader, buffer, writer = nil)
      container = writer ? writers : readers

      begin
        buffer << reader.read_nonblock(maxlen)
      rescue ::Errno::EAGAIN
      rescue ::EOFError
        buffer.force_encoding(
          reader.internal_encoding  ||
          reader.external_encoding  ||
          Encoding.default_internal ||
          Encoding.default_external
        ) if buffer.respond_to?(:force_encoding)

        close(container, writer || reader, !writer)
      end
    end

    def close(container, item, reading = nil)
      container.delete(item)
      reading ? item.close_read : item.close_write
    end

  end

    end
  end
end
