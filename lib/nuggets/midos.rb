begin
  require 'midos'
  module Nuggets; Midos = ::Midos; end

  warn "#{__FILE__}: Nuggets::Midos is deprecated, use Midos instead." unless ENV['NUGGETS_DEPRECATED_MIDOS']
rescue LoadError => err
  warn "#{__FILE__}: Nuggets::Midos is no longer available; install `midos' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_MIDOS']
end
