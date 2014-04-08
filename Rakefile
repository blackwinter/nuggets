require File.expand_path(%q{../lib/nuggets/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{ruby-nuggets},
      :version      => Nuggets::VERSION,
      :summary      => %q{Some extensions to the Ruby programming language.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :license      => %q{AGPL-3.0},
      :homepage     => :blackwinter,
      :dependencies => %w[],

      :development_dependencies => [
       #'amatch',          # enumerable/agrep
        'highline',        # cli
        'mime-types',      # content_type
        'open4',           # ruby
       #'rbzip2',          # rdf/compression
       #'rdf',             # rdf/{prefix,uri,compression}
       #'rdf-turtle',      # rdf/turtle
       #'rb-gsl',          # lsi
        'ruby-filemagic',  # content_type
        'safe_yaml',       # cli
       #'sinatra'          # sinatra
      ]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem first. (#{err})"
end

desc "Run all specs in isolation"
task 'spec:isolated' do
  ARGV.delete('spec:isolated')
  ARGV.unshift('spec')

  Dir['spec/*/**/*_spec.rb'].each { |spec|
    ENV['SPEC'] = spec
    system($0, *ARGV)
  }
end
