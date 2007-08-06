require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Generate documentation for ruby-nuggets'
Rake::RDocTask.new(:doc) { |rdoc|
  rdoc.title    = 'ruby-nuggets documentation'
  rdoc.rdoc_dir = 'doc'

  rdoc.options        <<
    '--line-numbers'  <<  # Include line numbers in the source code
    '--inline-source' <<  # Show method source code inline, rather
                          # than via a popup link
    '--all'           <<  # Include all methods (not just public)
                          # in the output
    '-c' << 'UTF-8'       # HTML character-set

  rdoc.rdoc_files.include(
    'README', 'COPYING', 'ChangeLog',
    'lib/**/*.rb'
  )
}

spec = Gem::Specification.new do |s|
  s.name             = 'ruby-nuggets'
  s.version          = '0.0.1.' << `svnversion`.chomp[/(\d+)/]
  s.author           = 'Jens Wille'
  s.email            = 'jens.wille@uni-koeln.de'
  s.summary          = 'Some extensions to the Ruby programming language.'
  s.files            = FileList['lib/**/*.rb'].to_a
  s.require_path     = 'lib'
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[README COPYING ChangeLog]
  s.rdoc_options     = %w[--main README --line-numbers --inline-source --all -c UTF-8]
end

desc 'Build gem package for ruby-nuggets'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
