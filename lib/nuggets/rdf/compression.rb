begin
  require 'turtle_reader/rdf/compression'
  warn "#{__FILE__}: 'nuggets/rdf/compression' is deprecated, use 'turtle_reader/rdf/compression' instead." unless ENV['NUGGETS_DEPRECATED_RDF_COMPRESSION']
rescue LoadError => err
  warn "#{__FILE__}: 'nuggets/rdf/compression' is no longer available; install `turtle_reader' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_RDF_COMPRESSION']
end
