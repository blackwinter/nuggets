require_relative 'lib/nuggets/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{nuggets},
      version:      Nuggets::VERSION,
      summary:      %q{Extending Ruby.},
      description:  %q{Various extensions to Ruby classes.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: %w[],

      development_dependencies: [
       #'amatch',         # enumerable/agrep
        'mime-types',     # content_type
        'open4',          # ruby
       #'ruby-filemagic'  # content_type
      ],

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

desc 'Run all specs in isolation'
task 'spec:isolated' do
  ARGV.delete('spec:isolated')
  ARGV.unshift('spec')

  Dir['spec/*/**/*_spec.rb'].each { |spec|
    ENV['SPEC'] = spec
    system($0, *ARGV)
  }
end

if RUBY_ENGINE == 'jruby'
  task spec: :enable_objspace

  task :enable_objspace do
    k, v = 'JRUBY_OPTS', '-X+O'
    ENV[k] ? ENV[k] += " #{v}" : ENV[k] = v
  end
end
