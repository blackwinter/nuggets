begin
  require 'turtle_reader/rdf/prefix'
  warn "#{__FILE__}: 'nuggets/rdf/prefix' is deprecated, use 'turtle_reader/rdf/prefix' instead." unless ENV['NUGGETS_DEPRECATED_RDF_PREFIX']
rescue LoadError => err
  warn "#{__FILE__}: 'nuggets/rdf/prefix' is no longer available; install `turtle_reader' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_RDF_PREFIX']
end
