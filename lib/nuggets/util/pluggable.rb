require 'nuggets/pluggable'
module Util; Pluggable = ::Nuggets::Pluggable; end

warn "#{__FILE__}: Util::Pluggable is deprecated, use Nuggets::Pluggable instead." unless ENV['NUGGETS_DEPRECATED_UTIL_PLUGGABLE']
