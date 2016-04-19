#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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

require 'nuggets/log_parser'

module Nuggets
  module LogParser
    module Rails

      LogParser.register(self)

      # Log line prefix
      PREFIX_RE = %r{
        \A
        (?:
          \[
            (\d+)                #  pid
            :
            (.*?)                #  host
          \]
          \s
        )?
        \s*
      }x

      # Log entry separator
      SEPARATOR_RE = %r{
        \s+\|\s+
      }x

      # Log line patterns
      ITEMS = [
        [:processing, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Processing\s+
            (\w+)                #  controller
            \#
            (\w+)                #  action
            \s+
            \(
              for\s+
              (.*?)              #  ip
              \s+at\s+
              (.*?)              #  datetime
            \)
            \s+
            \[
              (\w+)              #  request_method
            \]
          }xo,
          keys: [:controller, :action, :ip, :datetime, :request_method]
        }],
        [:session_id, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Session\sID:\s+
            (\S+)                #  sid
          }xo,
          keys: [:sid]
        }],
        [:parameters, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Parameters:\s+
            (\{.*\})             #  params
          }xo,  #}
          proc: lambda { |entry, md|
            entry[:params_hash] = md[3].hash
            entry[:params] = begin
              eval("$SAFE = 3\n#{md[3].gsub(/#<.*?>/, '%q{\&}')}", nil, __FILE__, __LINE__)  # !!!
            rescue SyntaxError, SecurityError
              {}
            end if ENV['NUGGETS_LOG_PARSER_RAILS_EVAL_PARAMS']
          }
        }],
        [:client_info, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Client\sinfo:\s+
            UA\s+=\s+
            (.*?)                #  user_agent
            #{SEPARATOR_RE}
            LANG\s+=\s+
            (.*)                 #  accept_language
          }xo,
          keys: [:user_agent, :accept_language]
        }],
        [:referer, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Referer:\s+
            (.*)                 #  referer
          }xo,
          keys: [:referer]
        }],
        [:meta, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Meta:\s+
            User\s+=\s+
            (.*?)                #  user_id
            #{SEPARATOR_RE}
            Institution\s+=\s+
            (.*)                 #  institution_id
          }xo,
          keys: [:user_id, :institution_id]
        }],
        [:stats, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Stats:\s+
            (.*)                 # flags
          }xo,
          proc: lambda { |entry, md|
            entry[:flags] = md[3].split(SEPARATOR_RE)
          }
        }],
        [:oauth, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            OAuth:\s+
            Token\s+=\s+
            (.*?)#(.*?)          #  token_type, token
            #{SEPARATOR_RE}
            User\s+=\s+
            (.*?)                #  user_id
            #{SEPARATOR_RE}
            Client\s+=\s+
            (.*)                 #  client_id
          }xo,
          keys: [:token_type, :token, :user_id, :client_id]
        }],
        [:benchmark, {
          re: %r{
            #{PREFIX_RE}         #  pid, host
            Completed\sin\s+
            (\S+)                #  runtime
            .*?
            (?:                  #- OPTIONAL
              #{SEPARATOR_RE}
              Rendering:\s+
              (\S+)              #  rendering_runtime
              .*?
            )?
            (?:                  #- OPTIONAL
              #{SEPARATOR_RE}
              DB:\s+
              (\S+)              #  db_runtime
              .*?
            )?
            (?:                  #- OPTIONAL
              #{SEPARATOR_RE}
              Mem:\s+
              \S+
              .*?
            )?
            #{SEPARATOR_RE}
            (.*?)                #  status
            \s+
            \[
              (.*)               #  request_uri
            \]
          }xo,
          keys: [:runtime, :rendering_runtime, :db_runtime, :status, :request_uri]
        }]
      ]

      ITEMS.each { |_, item|
        item[:proc] ||= lambda { |entry, md|
          item[:keys].each_with_index { |k, i|
            entry[k] = md[i + 3]  # 1 = pid, 2 = host
          }
        }
      }

      def parse_line(line, entry = {})
        ITEMS.each { |key, item|
          if md = item[:re].match(line)
            if key == :processing
              yield if block_given?
              entry[:pid], entry[:host] = md[1], md[2]
            end

            item[:proc][entry, md]

            break
          end
        }

        entry
      end

    end
  end
end
