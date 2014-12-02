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

require 'nuggets/ruby_mixin'

module Nuggets
  module Ruby

    include RubyMixin
    extend self

  end
end

def File.ruby; ::Nuggets::Ruby.ruby_command; end

if RUBY_ENGINE == 'jruby'
  def Process.ruby(*args, &block)
    argv = ::Nuggets::Ruby.ruby_options_to_argv(args)
    ::IO.popen4(*argv, &block); $?
  end
else
  begin
    require 'open4'

    def Process.ruby(*args, &block)
      argv = ::Nuggets::Ruby.ruby_options_to_argv(args)
      ::Open4.popen4(*argv, &block)
    end

    require 'nuggets/io/interact'

    def Process.interact_ruby(input, *args)
      ruby(*args) { |_, i, o, e|
        ::IO.interact({ input => i }, { o => $stdout, e => $stderr })
      }
    end
  rescue ::LoadError
  end
end
