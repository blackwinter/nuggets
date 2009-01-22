begin
  require 'hen'
rescue LoadError
  abort "Please install the 'hen' gem first."
end

require 'lib/nuggets/version'

Hen.lay! {{
  :rubyforge => {
    :package => 'ruby-nuggets'
  },

  :gem => {
    :version     => Nuggets::VERSION,
    :summary     => 'Some extensions to the Ruby programming language.',
    :files       => FileList['lib/**/*.rb'].to_a,
    :extra_files => FileList['[A-Z]*'].to_a
  }
}}

desc "Run all examples"
task :examples do
  ruby = "#{Config::CONFIG['RUBY_INSTALL_NAME']}#{Config::CONFIG['EXEEXT']}"

  Dir['lib/nuggets/*/**/*.rb'].each { |file|
    puts ">>>>> #{file} <<<<<"
    system(ruby, '-I', 'lib', file)
  }
end
