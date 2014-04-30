begin
  require 'mysql_parser'
  module Nuggets; module MySQL; Parser = ::MysqlParser; end; end

  warn "#{__FILE__}: Nuggets::MySQL::Parser is deprecated, use MysqlParser instead." unless ENV['NUGGETS_DEPRECATED_MYSQL']
rescue LoadError => err
  warn "#{__FILE__}: Nuggets::MySQL::Parser is no longer available; install `mysql_parser' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_MYSQL']
end
