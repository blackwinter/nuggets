require 'nuggets/cli'
module Util; CLI = ::Nuggets::CLI; end

warn "#{__FILE__}: Util::CLI is deprecated, use Nuggets::CLI instead." unless ENV['NUGGETS_DEPRECATED_UTIL_CLI']
