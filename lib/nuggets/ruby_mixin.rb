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

require 'rbconfig'

module Nuggets

  # Originally based on Phusion Passenger's
  # {PlatformInfo}[https://github.com/FooBarWidget/passenger/blob/release-3.0.2/lib/phusion_passenger/platform_info/ruby.rb]
  # module.
  #
  #--
  # Phusion Passenger - http://www.modrails.com/
  # Copyright (c) 2010 Phusion
  #
  # "Phusion Passenger" is a trademark of Hongli Lai & Ninh Bui.
  #
  # Permission is hereby granted, free of charge, to any person obtaining a
  # copy of this software and associated documentation files (the "Software"),
  # to deal in the Software without restriction, including without limitation
  # the rights to use, copy, modify, merge, publish, distribute, sublicense,
  # and/or sell copies of the Software, and to permit persons to whom the
  # Software is furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  #++

  module RubyMixin

    CONFIG = ::RbConfig::CONFIG

    # Store original $GEM_HOME value so that even if the app customizes
    # $GEM_HOME we can still work with the original value.
    if gem_home = ::ENV['GEM_HOME']
      gem_home = gem_home.strip.freeze
      gem_home = nil if gem_home.empty?
    end

    GEM_HOME = gem_home

    RUBY_ENGINE = defined?(::RUBY_ENGINE) ? ::RUBY_ENGINE : 'ruby'

    RUBY_PLATFORM = ::RUBY_ENGINE == 'jruby' ? CONFIG['target_os'] : ::RUBY_PLATFORM

    OSX_RUBY_RE = %r{\A/System/Library/Frameworks/Ruby.framework/Versions/.*?/usr/bin/ruby\Z}

    # Returns correct command for invoking the current Ruby interpreter.
    def ruby_command
      defined?(@ruby_command) ? @ruby_command : @ruby_command = ruby_executable
    end

    attr_writer :ruby_command

    # Returns the full path to the current Ruby interpreter's executable file.
    # This might not be the actual correct command to use for invoking the Ruby
    # interpreter; use ruby_command instead.
    def ruby_executable
      @ruby_executable ||= begin
        dir, name, ext = CONFIG.values_at(*%w[bindir RUBY_INSTALL_NAME EXEEXT])
        ::File.join(dir, name + ext).sub(/.*\s.*/m, '"\&"')
      end
    end

    attr_writer :ruby_executable

    # Locates a Ruby tool command +name+, e.g. 'gem', 'rake', 'bundle', etc. Instead
    # of naively looking in $PATH, this function uses a variety of search heuristics
    # to find the command that's really associated with the current Ruby interpreter.
    # It should never locate a command that's actually associated with a different
    # Ruby interpreter.
    #
    # NOTE: The return value may not be the actual correct invocation for the tool.
    # Use command_for_ruby_tool for that.
    #
    # Returns +nil+ when nothing's found.
    def locate_ruby_tool(name, extensions = ['', CONFIG['EXEEXT']].compact.uniq)
      # Deduce Ruby's --program-prefix and --program-suffix from its install name
      # and transform the given input name accordingly.
      #
      #   "rake" => "jrake", "rake1.8", etc.
      [name, CONFIG['RUBY_INSTALL_NAME'].sub('ruby', name)].uniq.each { |basename|
        extensions.each { |ext|
          result = locate_ruby_tool_by_basename(basename + ext) and return result
        }
      }

      nil
    end

    # Returns the correct command string for invoking the +name+ executable
    # that belongs to the current Ruby interpreter. Returns +nil+ if the
    # command is not found.
    #
    # If the command executable is a Ruby program, then we need to run it
    # in the correct Ruby interpreter just in case the command doesn't
    # have the correct shebang line; we don't want a totally different
    # Ruby than the current one to be invoked.
    def command_for_ruby_tool(name)
      filename = respond_to?(name) ? send(name) : locate_ruby_tool(name)
      shebang_command(filename) =~ /ruby/ ? "#{ruby_command} #{filename}" : filename
    end

    def self.define_ruby_tool(name)
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} ||= locate_ruby_tool('#{name}')
        end

        attr_writer :#{name}

        def #{name}_command
          @#{name}_command ||= command_for_ruby_tool('#{name}')
        end

        attr_writer :#{name}_command
      EOT
    end

    %w[gem rake rspec].each { |name| define_ruby_tool(name) }

    def ruby_options_to_argv(args, ruby_command = ruby_command())
      argv = [ruby_command]

      ruby_options_from_hash(args.pop, argv) if args.last.is_a?(::Hash)

      argv.concat(args.map! { |arg| arg.to_s.strip })
    end

    def ruby_options_from_hash(hash, argv = [])
      hash.each { |key, val|
        opt = "-#{key.to_s[0, 1]}"

        if val.is_a?(::Array)
          val.each { |v| argv << opt << v.to_s }
        elsif opt == '-e'
          argv << opt << val.to_s
        elsif val != false
          argv << "#{opt}#{val unless val == true}"
        end
      }

      argv
    end

    private

    def locate_ruby_tool_by_basename(name)
      # On OS X we must look for Ruby binaries in /usr/bin.
      # RubyGems puts executables (e.g. 'rake') in there, not in
      # /System/Libraries/(...)/bin.
      dir = ::RUBY_PLATFORM =~ /darwin/ && ruby_command =~ OSX_RUBY_RE ?
        '/usr/bin' : ::File.dirname(ruby_command)

      filename = executable_filename(dir, name) and return filename

      # RubyGems might put binaries in a directory other
      # than Ruby's bindir. Debian packaged RubyGems and
      # DebGem packaged RubyGems are the prime examples.
      filename = executable_filename(::Gem.bindir, name) and return filename

      # Looks like it's not in the RubyGems bindir. Search in $PATH, but
      # be very careful about this because whatever we find might belong
      # to a different Ruby interpreter than the current one.
      ::ENV['PATH'].split(::File::PATH_SEPARATOR).each { |path|
        if filename = executable_filename(path, name)
          return filename if shebang_command(filename) == ruby_command
        end
      }

      nil
    end

    def executable_filename(dir, name)
      filename = ::File.join(dir, name)
      filename if ::File.file?(filename) && ::File.executable?(filename)
    end

    def shebang_command(filename)
      ::File.foreach(filename) { |line|
        return $1 if line =~ /\A#!\s*(\S*)/

        # Allow one extra line for magic comment.
        break if $. > 1
      }

      nil
    end

  end

end
