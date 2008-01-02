# Utilizes global rake-tasks: alias rake="rake -r rake -R /path/to/rakelibdir"
# (Base tasks at <http://prometheus.khi.uni-koeln.de/svn/scratch/rake-tasks/>)

require 'lib/nuggets/version'

FILES = FileList['lib/**/*.rb'].to_a
RDOCS = %w[README COPYING ChangeLog]
OTHER = FileList['[A-Z]*'].to_a

task(:doc_spec) {{
  :title      => 'ruby-nuggets Application documentation',
  :rdoc_files => RDOCS + FILES
}}

task(:gem_spec) {{
  :name             => 'ruby-nuggets',
  :version          => Nuggets::VERSION,
  :summary          => 'Some extensions to the Ruby programming language.',
  :files            => FILES + OTHER,
  :require_path     => 'lib',
  :extra_rdoc_files => RDOCS
}}
