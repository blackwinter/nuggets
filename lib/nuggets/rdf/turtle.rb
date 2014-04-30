begin
  require 'turtle_reader'
  module Nuggets; module RDF; Turtle = ::TurtleReader; end; end

  warn "#{__FILE__}: Nuggets::RDF::Turtle is deprecated, use TurtleReader instead." unless ENV['NUGGETS_DEPRECATED_RDF_TURTLE']
rescue LoadError => err
  warn "#{__FILE__}: Nuggets::RDF::Turtle is no longer available; install `turtle_reader' instead. (#{err})" unless ENV['NUGGETS_DEPRECATED_RDF_TURTLE']
end
