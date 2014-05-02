require 'nuggets/uri/content_type'

describe_extended URI, Nuggets::URI::ContentTypeMixin, true do

  let(:cache) { Nuggets::URI::RedirectMixin::URI_REDIRECT_HTTP_CACHE }

  {
    'http://www.google.de'                                         => 'text/html',
    'http://example.de/misc/'                                      => 'text/html',
    'http://example.de/misc/ww.png'                                => 'image/png',
    'http://example.de/misc/suicide_is_painless.mid'               => 'audio/midi',
    'http://example.de/misc/fugmann/wille_-_fugmann-slides.tar.gz' => 'application/x-gzip',
    'http://example.de/misc/i_hate_ms.pdf'                         => 'application/pdf',
    'http://example.de/bla'                                        => false,
    'http://blawinter.de'                                          => nil,
    'htp://www.google.de'                                          => nil,
    'ftp://example.org'                                            => nil,
    'www.google.de'                                                => nil
  }.each { |u, t|
    example {
      begin
        req, res = double(Net::HTTP), double(Net::HTTPResponse)

        req.stub(:use_ssl=)
        req.stub(:use_ssl?)

        res.stub(:success?).and_return(t)
        res.stub(:content_type).and_return(t)

        req.stub(:head).and_return(res)

        cache.update([(uri = URI(u)).host, uri.port] => req)

        URI.content_type(u).should == t
        cache.size.should == 1
      ensure
        cache.clear
      end
    }
  }

end
