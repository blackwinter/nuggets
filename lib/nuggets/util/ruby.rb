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
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for    #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.              #
#                                                                             #
###############################################################################
#++

require 'rbconfig'

module Util

  # Heavily based on Phusion Passenger's PlatformInfo module; see
  # {their code}[https://github.com/FooBarWidget/passenger/blob/release-3.0.2/lib/phusion_passenger/platform_info/ruby.rb].
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

  module Ruby

    extend self

    CONFIG = RbConfig::CONFIG

    # Store original $GEM_HOME value so that even if the app customizes
    # $GEM_HOME we can still work with the original value.
    if gem_home = ENV['GEM_HOME']
      gem_home = gem_home.strip.freeze
      gem_home = nil if gem_home.empty?
    end

    GEM_HOME = gem_home

    RUBY_ENGINE = defined?(::RUBY_ENGINE) ? ::RUBY_ENGINE : 'ruby'

    OSX_RUBY_RE = %r{\A/System/Library/Frameworks/Ruby.framework/Versions/.*?/usr/bin/ruby\Z}

    UPDATE_RVM = %q{Please update RVM by running 'rvm update --head && rvm reload && rvm repair all'.}  # :nodoc:

    # Returns correct command for invoking the current Ruby interpreter.
    # In case of RVM this function will return the path to the RVM wrapper script
    # that executes the current Ruby interpreter in the currently active gem set.
    def ruby_command
      return @ruby_command if defined?(@ruby_command)

      return @ruby_command = ruby_executable unless rvm?

      if name = rvm_ruby_string and dir = rvm_path
        if File.exist?(filename = File.join(dir, 'wrappers', name, 'ruby'))
          # Old wrapper scripts reference $HOME which causes
          # things to blow up when run by a different user.
          return @ruby_command = filename unless File.read(filename).include?('$HOME')
        end

        abort 'Your RVM wrapper scripts are too old. ' << UPDATE_RVM
      end

      # Something's wrong with the user's RVM installation.
      # Raise an error so that the user knows this instead of
      # having things fail randomly later on.
      # 'name' is guaranteed to be non-nil because rvm_ruby_string
      # already raises an exception on error.
      abort 'Your RVM installation appears to be broken: the RVM path cannot be found. ' <<
            'Please fix your RVM installation or contact the RVM developers for support.'
    end

    # Returns the full path to the current Ruby interpreter's executable file.
    # This might not be the actual correct command to use for invoking the Ruby
    # interpreter; use ruby_command instead.
    def ruby_executable
      @ruby_executable ||= begin
        dir, name, ext = CONFIG.values_at(*%w[bindir RUBY_INSTALL_NAME EXEEXT])
        File.join(dir, name + ext).sub(/.*\s.*/m, '"\&"')
      end
    end

    # Returns whether the Ruby interpreter supports process forking.
    def ruby_supports_fork?
      # MRI >= 1.9.2's respond_to? returns false
      # for methods that are not implemented.
      Process.respond_to?(:fork) &&
      RUBY_ENGINE != 'jruby'     &&
      RUBY_ENGINE != 'macruby'   &&
      CONFIG['target_os'] !~ /mswin|windows|mingw/
    end

    # Returns whether the current Ruby interpreter is managed by RVM.
    def rvm?
      CONFIG['bindir'] =~ %r{/\.?rvm/}
    end

    # If the current Ruby interpreter is managed by RVM, returns the
    # directory in which RVM places its working files. Otherwise returns
    # +nil+.
    def rvm_path
      return @rvm_path if defined?(@rvm_path)

      return @rvm_path = nil unless rvm?

      [ENV['rvm_path'], '~/.rvm', '/usr/local/rvm'].compact.each { |path|
        path = File.expand_path(path)
        return @rvm_path = path if File.directory?(path)
      }

      # Failure to locate the RVM path is probably caused by the
      # user customizing $rvm_path. Older RVM versions don't
      # export $rvm_path, making us unable to detect its value.
      abort 'Unable to locate the RVM path. Your RVM ' <<
            'installation is probably too old. ' << UPDATE_RVM
    end

    # If the current Ruby interpreter is managed by RVM, returns the
    # RVM name which identifies the current Ruby interpreter plus the
    # currently active gemset, e.g. something like this:
    # "ruby-1.9.2-p0@mygemset"
    #
    # Returns +nil+ otherwise.
    def rvm_ruby_string
      return @rvm_ruby_string if defined?(@rvm_ruby_string)

      return @rvm_ruby_string = nil unless rvm?

      # RVM used to export the necessary information through
      # environment variables, but doesn't always do that anymore
      # in the latest versions in order to fight env var pollution.
      # Scanning $LOAD_PATH seems to be the only way to obtain
      # the information.

      # Getting the RVM name of the Ruby interpreter ("ruby-1.9.2")
      # isn't so hard, we can extract it from the #ruby_executable
      # string. Getting the gemset name is a bit harder, so let's
      # try various strategies...

      # $GEM_HOME usually contains the gem set name.
      return @rvm_ruby_string = File.basename(GEM_HOME) if GEM_HOME && GEM_HOME.include?('rvm/gems/')

      # User somehow managed to nuke $GEM_HOME. Extract info from $LOAD_PATH.
      $LOAD_PATH.each { |path| return @rvm_ruby_string = $1 if path =~ %r{^.*rvm/gems/([^/]+)} }

      # On Ruby 1.9, $LOAD_PATH does not contain any gem paths until
      # at least one gem has been required so the above can fail.
      # We're out of options now, we can't detect the gem set.
      # Raise an exception so that the user knows what's going on
      # instead of having things fail in obscure ways later.
      abort 'Unable to autodetect the currently active RVM gem set ' <<
            "name. Please contact this program's author for support."
    end

    # Returns either 'sudo' or 'rvmsudo' depending on whether the current
    # Ruby interpreter is managed by RVM.
    def ruby_sudo_command
      "#{'rvm' if rvm?}sudo"
    end

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
    def locate_ruby_tool(name)
      extensions = ['', CONFIG['EXEEXT']].compact.uniq

      # Deduce Ruby's --program-prefix and --program-suffix from its install name
      # and transform the given input name accordingly.
      #
      #   "rake" => "jrake", "rake1.8", etc
      [name, CONFIG['RUBY_INSTALL_NAME'].sub('ruby', name)].uniq.each { |basename|
        extensions.each { |ext|
          result = locate_ruby_tool_by_basename("#{basename}#{ext}")
          return result if result
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
    #
    # If it's not a Ruby program then it's probably a wrapper
    # script as is the case with e.g. RVM (~/.rvm/wrappers).
    def command_for_ruby_tool(name)
      filename = respond_to?(name) ? send(name) : locate_ruby_tool(name)
      shebang_command(filename) =~ /ruby/ ? "#{ruby_command} #{filename}" : filename
    end

    %w[gem rake rspec].each { |name|
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} ||= locate_ruby_tool('#{name}')
        end

        def #{name}_command
          @#{name}_command ||= command_for_ruby_tool('#{name}')
        end
      EOT
    }

    def ruby_options_to_argv(args, ruby_command = ruby_command)
      argv = [ruby_command]

      args.pop.each { |key, val|
        opt = "-#{key.to_s[0, 1]}"

        if val.is_a?(Array)
          val.each { |wal|
            argv << opt << wal.to_s
          }
        else
          if opt == '-e'
            argv << opt << val.to_s
          elsif val != false
            argv << "#{opt}#{val unless val == true}"
          end
        end
      } if args.last.is_a?(Hash)

      argv.concat(args.map! { |arg| arg.to_s.strip })
    end

    private

    def locate_ruby_tool_by_basename(name)
      dir = if RUBY_PLATFORM =~ /darwin/ && ruby_command =~ OSX_RUBY_RE
        # On OS X we must look for Ruby binaries in /usr/bin.
        # RubyGems puts executables (e.g. 'rake') in there, not in
        # /System/Libraries/(...)/bin.
        '/usr/bin'
      else
        File.dirname(ruby_command)
      end

      filename = File.join(dir, name)
      return filename if File.file?(filename) && File.executable?(filename)

      # RubyGems might put binaries in a directory other
      # than Ruby's bindir. Debian packaged RubyGems and
      # DebGem packaged RubyGems are the prime examples.
      begin
        require 'rubygems' unless defined?(Gem)

        filename = File.join(Gem.bindir, name)
        return filename if File.file?(filename) && File.executable?(filename)
      rescue LoadError
      end

      # Looks like it's not in the RubyGems bindir. Search in $PATH, but
      # be very careful about this because whatever we find might belong
      # to a different Ruby interpreter than the current one.
      ENV['PATH'].split(File::PATH_SEPARATOR).each { |path|
        filename = File.join(path, name)

        if File.file?(filename) && File.executable?(filename)
          return filename if shebang_command(filename) == ruby_command
        end
      }

      nil
    end

    def shebang_command(filename)
      File.foreach(filename) { |line|
        return $1 if line =~ /\A#!\s*(\S*)/

        # Allow one extra line for magic comment.
        break if $. > 1
      }
    end

  end

end

def File.ruby; Util::Ruby.ruby_command; end

begin
  require 'open4'

  def Process.ruby(*args)
    argv = Util::Ruby.ruby_options_to_argv(args, File.ruby)
    Open4.popen4(*argv, &block_given? ? Proc.new : nil)
  end
rescue LoadError
end
