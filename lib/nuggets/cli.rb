begin
  require 'cyclops'
  module Nuggets; CLI = ::Cyclops; end

  warn "#{__FILE__}: Nuggets::CLI is deprecated, use Cyclops instead."
rescue LoadError => err
  warn "#{__FILE__}: Nuggets::CLI is no longer available; install `cyclops' instead. (#{err})"
end
