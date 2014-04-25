require 'nuggets/log_parser'
module Util; LogParser = ::Nuggets::LogParser; end

warn "#{__FILE__}: Util::LogParser is deprecated, use Nuggets::LogParser instead." unless ENV['NUGGETS_DEPRECATED_UTIL_LOG_PARSER']
