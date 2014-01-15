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

require 'rdf/turtle'

module RDF
  class Turtle::Reader

    PARSE_OPTIONS = {
      :branch         => BRANCH,
      :first          => FIRST,
      :follow         => FOLLOW,
      :reset_on_start => true
    }

    def closed?
      @input.closed?
    end

    def parse_prologue
      parse_internal { break }
      rewind
      [base_uri, prefixes]
    end

    def parse_statements
      parse_internal { |context, _, *data|
        if context == :statement
          data[3] = { :context => data[3] }
          yield Statement.new(*data)
        end
      }
    end

    private

    def parse_internal(&block)
      parse(@input, START, @options.merge(PARSE_OPTIONS), &block)
    rescue => err
      err.message << " (line #{lineno})"
      raise
    end

  end
end
