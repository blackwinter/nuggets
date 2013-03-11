require File.expand_path(%q{../lib/nuggets/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{prometheus},
      :package => %q{ruby-nuggets}
    },

    :gem => {
      :version => Nuggets::VERSION,
      :summary => %q{Some extensions to the Ruby programming language.},
      :author  => %q{Jens Wille},
      :email   => %q{jens.wille@gmail.com}
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
