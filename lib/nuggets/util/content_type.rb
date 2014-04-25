require 'nuggets/content_type'
module Util; ContentType = ::Nuggets::ContentType; end

warn "#{__FILE__}: Util::ContentType is deprecated, use Nuggets::ContentType instead." unless ENV['NUGGETS_DEPRECATED_UTIL_CONTENT_TYPE']
