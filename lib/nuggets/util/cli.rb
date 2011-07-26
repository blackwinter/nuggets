#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
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

require 'optparse'
require 'yaml'
require 'zlib'
require 'highline'

module Util

  class CLI

    class << self

      def usage(prog)
        "Usage: #{prog} [-h|--help] [options]"
      end

      def version
        parent_const_get(:VERSION)
      end

      def defaults
        {}
      end

      def execute(*args)
        new.execute(*args)
      end

      private

      def parent_const_get(const, range = 0...-1)
        name.split('::').inject([Object]) { |memo, name|
          memo << memo.last.const_get(name)
        }.reverse[range].each { |mod|
          return mod.const_get(const) if mod.const_defined?(const)
        }

        raise NameError, "uninitialized constant #{self}::#{const}"
      end

    end

    attr_reader :options, :config, :defaults
    attr_reader :stdin, :stdout, :stderr

    attr_accessor :prog

    def initialize(defaults = nil, *args)
      @defaults, @prog = defaults || self.class.defaults, $0

      init(*args)

      # prevent backtrace on ^C
      trap(:INT) { exit 130 }
    end

    def progname
      File.basename(prog)
    end

    def usage
      self.class.usage(prog)
    end

    def version
      self.class.version
    end

    def execute(arguments = ARGV, *inouterr)
      reset(*inouterr)
      parse_options(arguments)
      run(arguments)
    rescue => err
      raise if $VERBOSE
      abort "#{err.backtrace.first}: #{err} (#{err.class})"
    ensure
      options.each_value { |value|
        value.close if value.is_a?(Zlib::GzipWriter)
      }
    end

    def reset(stdin = STDIN, stdout = STDOUT, stderr = STDERR)
      @stdin, @stdout, @stderr = stdin, stdout, stderr
      @options, @config = {}, {}
    end

    private

    def init(*args)
      reset
    end

    def ask(question, &block)
      HighLine.new(stdin, stdout).ask(question, &block)
    end

    def warn(msg)
      stderr.puts(msg)
    end

    def quit(msg = nil, include_usage = msg != false)
      out = []

      out << "#{progname}: #{msg}" if msg
      out << usage if include_usage

      abort out.any? && out.join("\n\n")
    end

    def abort(msg = nil, status = 1)
      warn(msg) if msg
      exit(status)
    end

    def exit(status = 0)
      Kernel.exit(status)
    end

    def open_file_or_std(file, write = false)
      if file == '-'
        write ? stdout : stdin
      else
        gz = file =~ /\.gz\z/i

        if write
          gz ? Zlib::GzipWriter.open(file) : File.open(file, 'w')
        else
          quit "No such file: #{file}" unless File.readable?(file)
          (gz ? Zlib::GzipReader : File).open(file)
        end
      end
    end

    def load_config(file = options[:config] || defaults[:config])
      @config = YAML.load_file(file) if File.readable?(file)
    end

    def merge_config(args = [config, defaults])
      args.each { |hash| hash.each { |key, value|
        options[key] = value unless options.has_key?(key)
      } }
    end

    def parse_options(arguments)
      option_parser.parse!(arguments)

      load_config
      merge_config
    end

    def option_parser
      OptionParser.new { |opts|
        opts.banner = usage

        pre_opts(opts)

        opts.separator ''
        opts.separator 'Options:'

        opts(opts)

        opts.separator ''
        opts.separator 'Generic options:'

        generic_opts(opts)
        post_opts(opts)
      }
    end

    def pre_opts(opts)
    end

    def opts(opts)
    end

    def generic_opts(opts)
      opts.on('-h', '--help', 'Print this help message and exit') {
        abort opts.to_s
      }

      opts.on('--version', 'Print program version and exit') {
        abort "#{progname} v#{version}"
      }
    end

    def post_opts(opts)
    end

  end

end
