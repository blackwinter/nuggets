require 'nuggets/log_parser/apache'
module Util; LogParser = ::Nuggets::LogParser; end

warn "#{__FILE__}: Util::LogParser::Apache is deprecated, use Nuggets::LogParser::Apache instead." unless ENV['NUGGETS_DEPRECATED_UTIL_LOG_PARSER_APACHE']
