require 'nuggets/ruby'
module Util; Ruby = ::Nuggets::Ruby; end

warn "#{__FILE__}: Util::Ruby is deprecated, use Nuggets::Ruby instead." unless ENV['NUGGETS_DEPRECATED_UTIL_RUBY']
