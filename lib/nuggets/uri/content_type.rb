require 'nuggets/uri/content_type_mixin'

module URI
  extend Nuggets::URI::ContentTypeMixin
end

if $0 == __FILE__
  %w[
    http://www.google.de
    htp://www.google.de
    www.google.de
    http://blackwinter.de/misc/
    http://blackwinter.de/misc/ww.png
    http://blackwinter.de/misc/suicide_is_painless.mid
    http://blackwinter.de/misc/expand_macros.pl.gz
    http://blackwinter.de/misc/blanc60302523.nth
    http://blackwinter.de/bla
    http://blawinter.de
    http://192.168.12.34/foo/bar
  ].each { |u|
    p [u, URI.content_type(u)]
  }
end
