require 'nuggets/uri/exist'

describe_extended URI, Nuggets::URI::ExistMixin, true do

  let(:cache) { Nuggets::URI::RedirectMixin::URI_REDIRECT_HTTP_CACHE }

  %w[
    http://www.google.de
    http://example.de
    http://example.de/bla
    http://example.de/index.html
    http://example.de/index.htm
    http://xuugle.de
  ].each { |u|
    [true, false, nil].each { |s|
      example {
        begin
          req, res = double(Net::HTTP), double(Net::HTTPResponse)

          req.stub(:use_ssl=)
          req.stub(:use_ssl?)

          res.stub(:success?).and_return(s)

          req.stub(:head).and_return(res)

          cache.update([(uri = URI(u)).host, uri.port] => req)

          URI.exist?(u).should == s
          cache.size.should == 1
        ensure
          cache.clear
        end
      }
    }
  }

  %w[
    htp://www.google.de
    ftp://example.org
    www.google.de
  ].each { |u|
    example {
      URI.exist?(u).should be_nil
      cache.should be_empty
    }
  }

end
