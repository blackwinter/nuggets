require %q{lib/nuggets/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{prometheus},
      :package => %q{ruby-nuggets}
    },

    :gem => {
      :version     => Nuggets::VERSION,
      :summary     => 'Some extensions to the Ruby programming language.',
      :files       => FileList['lib/**/*.rb'].to_a,
      :extra_files => FileList['[A-Z]*', '.rspec', 'spec/**/*.rb'].to_a
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
