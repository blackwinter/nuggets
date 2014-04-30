begin
  require 'turtle_reader/rdf/turtle/reader'
  warn "#{__FILE__}: 'nuggets/rdf/turtle/reader' is deprecated, use 'turtle_reader/rdf/turtle/reader' instead." unless ENV['NUGGETS_DEPRECATED_RDF_TURTLE_READER']
rescue LoadError => err
  warn "#{__FILE__}: 'nuggets/rdf/turtle/reader' is no longer available; install `turtle_reader' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_RDF_TURTLE_READER']
end
