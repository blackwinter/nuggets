require 'nuggets/log_parser/rails'
module Util; LogParser = ::Nuggets::LogParser; end

warn "#{__FILE__}: Util::LogParser::Rails is deprecated, use Nuggets::LogParser::Rails instead." unless ENV['NUGGETS_DEPRECATED_UTIL_LOG_PARSER_RAILS']
