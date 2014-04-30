begin
  require 'turtle_reader/rdf/uri'
  warn "#{__FILE__}: 'nuggets/rdf/uri' is deprecated, use 'turtle_reader/rdf/uri' instead." unless ENV['NUGGETS_DEPRECATED_RDF_URI']
rescue LoadError => err
  warn "#{__FILE__}: 'nuggets/rdf/uri' is no longer available; install `turtle_reader' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_RDF_URI']
end
