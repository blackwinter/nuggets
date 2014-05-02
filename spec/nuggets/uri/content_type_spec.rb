require 'nuggets/uri/content_type'

describe_extended URI, Nuggets::URI::ContentTypeMixin, true do

  %w[
    http://www.google.de
    http://blackwinter.de/misc/
  ].each { |u|
    example { URI.content_type(u).should == 'text/html' }
  }

  %w[
    htp://www.google.de
    www.google.de
    http://blawinter.de
  ].each { |u|
    example { URI.content_type(u).should == nil }
  }

  %w[
    http://blackwinter.de/bla
  ].each { |u|
    example { URI.content_type(u).should == false }
  }

  {
    'http://blackwinter.de/misc/ww.png'                                => 'image/png',
    'http://blackwinter.de/misc/suicide_is_painless.mid'               => 'audio/midi',
    'http://blackwinter.de/misc/fugmann/wille_-_fugmann-slides.tar.gz' => 'application/x-gzip',
    'http://blackwinter.de/misc/i_hate_ms.pdf'                         => 'application/pdf'
  }.each { |u, t|
    example { URI.content_type(u).should == t }
  }

end
