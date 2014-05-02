require 'nuggets/file/sub'
require 'nuggets/tempfile/open'

describe_extended File, Nuggets::File::SubMixin, true do

  before :each do
    @txt = <<-EOT.freeze
The fox went out on a chilly night
Prayed for the moon to give him light
For he had many a mile to go that night
Before he reached the town o
    EOT

    @res1 = <<-EOT.freeze
The fox went out on a chilly nXIGHTX
Prayed for the moon to give him light
For he had many a mile to go that night
Before he reached the town o
    EOT

    @res2 = <<-EOT.freeze
The fox went out on a chilly nXIGHTX
Prayed for the moon to give him lXIGHTX
For he had many a mile to go that nXIGHTX
Before he reached the town o
    EOT
  end

  example do
    tempfile { |path|
      res = File.sub(path, /ight/, 'XIGHTX')
      res.should == @res1
      @txt.should_not == @res1
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.sub(path, /XightX/, 'xIGHTx')
      res.should == @txt
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.sub(path, /ight/) { |m| "X#{m.upcase}X" }
      res.should == @res1
      @txt.should_not == @res1
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.sub(path, /XightX/) { |m| "x#{m.upcase}x" }
      res.should == @txt
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.gsub(path, /ight/, 'XIGHTX')
      res.should == @res2
      @txt.should_not == @res2
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.gsub(path, /ight/) { |m| "X#{m.upcase}X" }
      res.should == @res2
      @txt.should_not == @res2
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.sub!(path, /ight/, 'XIGHTX')
      res.should == @res1
      @txt.should_not == @res1
      File.read(path).should == @res1
    }
  end

  example do
    tempfile { |path|
      res = File.sub!(path, /XightX/, 'xIGHTx')
      res.should be_nil
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.sub!(path, /ight/) { |m| "X#{m.upcase}X" }
      res.should == @res1
      @txt.should_not == @res1
      File.read(path).should == @res1
    }
  end

  example do
    tempfile { |path|
      res = File.sub!(path, /XightX/) { |m| "x#{m.upcase}x" }
      res.should be_nil
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.gsub!(path, /ight/, 'XIGHTX')
      res.should == @res2
      @txt.should_not == @res2
      File.read(path).should == @res2
    }
  end

  example do
    tempfile { |path|
      res = File.gsub!(path, /ight/) { |m| "X#{m.upcase}X" }
      res.should == @res2
      @txt.should_not == @res2
      File.read(path).should == @res2
    }
  end

  example do
    lambda { File.sub(tempfile, /ight/, 'XIGHTX') }.should raise_error(Errno::ENOENT)
  end

  example do
    lambda { File.sub!(tempfile, /ight/, 'XIGHTX') }.should raise_error(Errno::ENOENT)
  end

  example do
    lambda { File.gsub(tempfile, /ight/, 'XIGHTX') }.should raise_error(Errno::ENOENT)
  end

  example do
    lambda { File.gsub!(tempfile, /ight/, 'XIGHTX') }.should raise_error(Errno::ENOENT)
  end

end
