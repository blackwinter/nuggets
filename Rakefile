require 'rake'
require 'rake/rdoctask'

desc "Generate documentation for ruby-nuggets"
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
