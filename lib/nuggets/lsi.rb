begin
  require 'lsi4r'
  module Nuggets; LSI = ::Lsi4R; end

  warn "#{__FILE__}: Nuggets::LSI is deprecated, use Lsi4R instead."
rescue LoadError => err
  warn "#{__FILE__}: Nuggets::LSI is no longer available; install `lsi4r' instead. (#{err})"
end
