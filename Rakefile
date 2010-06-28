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
      :extra_files => FileList['[A-Z]*'].to_a
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
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
