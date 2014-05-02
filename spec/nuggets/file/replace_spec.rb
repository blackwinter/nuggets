require 'nuggets/file/replace'
require 'nuggets/tempfile/open'

describe_extended File, Nuggets::File::ReplaceMixin, true do

  before :each do
    @txt = <<-EOT.freeze
The fox went out on a chilly night
Prayed for the moon to give him light
For he had many a mile to go that night
Before he reached the town o
    EOT

    @res1 = <<-EOT.freeze
He ran til he came to a great big bin
Where the ducks and the geese were kept therein
Said, a couple of you are going to grease my chin
Before I leave this town o
    EOT

    @res2 = <<-EOT.freeze
THE FOX WENT OUT ON A CHILLY NIGHT
PRAYED FOR THE MOON TO GIVE HIM LIGHT
FOR HE HAD MANY A MILE TO GO THAT NIGHT
BEFORE HE REACHED THE TOWN O
    EOT
  end

  example do
    tempfile { |path|
      res = File.replace(path) { @res1 }
      res.should == @res1
      File.read(path).should == @res1
    }
  end

  example do
    tempfile { |path|
      res = File.replace(path) { |content| content }
      res.should == @txt
      File.read(path).should == @txt
    }
  end

  example do
    tempfile { |path|
      res = File.replace(path) { |content| @res1 }
      res.should == @res1
      File.read(path).should == @res1
    }
  end

  example do
    tempfile { |path|
      res = File.replace(path) { |content| content.upcase }
      res.should == @res2
      File.read(path).should == @res2
    }
  end

  example do
    lambda { File.replace(tempfile) { @res1 } }.should raise_error(Errno::ENOENT)
  end

  example do
    begin
      res = File.replace(path = tempfile, true) { @res1 }
      res.should == @res1
      File.read(path).should == @res1
    ensure
      File.unlink(path) if path
    end
  end

  example do
    begin
      res = File.replace(path = tempfile, true) { |content| content }
      res.should == ''
      File.read(path).should == ''
    ensure
      File.unlink(path) if path
    end
  end

  example do
    begin
      res = File.replace(path = tempfile, true) { |content| @res1 }
      res.should == @res1
      File.read(path).should == @res1
    ensure
      File.unlink(path) if path
    end
  end

end
