require 'nuggets/hash/nest'

describe_extended Hash, Nuggets::Hash::NestMixin, true do

  example do
    hash = Hash.nest
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_nil
    hash.should have_key(:a)
  end

  example do
    hash = Hash.nest(0, 1)
    hash.should be_an_instance_of(Hash)

    hash[:a].should == 1
    hash.should have_key(:a)
  end

  example do
    hash = Hash.nest(1)
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_an_instance_of(Hash)
    hash.should have_key(:a)

    hash[:a][:b].should be_nil
    hash[:a].should have_key(:b)
  end

  example do
    hash = Hash.nest(1, 1)
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_an_instance_of(Hash)
    hash.should have_key(:a)

    hash[:a][:b].should == 1
    hash[:a].should have_key(:b)
  end

  example do
    hash = Hash.nest(1, [])
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_an_instance_of(Hash)
    hash.should have_key(:a)

    hash[:a][:b].should == []
    hash[:a].should have_key(:b)

    hash[:a][:b] << 1
    hash[:a][:b].should == [1]

    hash[:a][:c] << 2
    hash[:a][:c].should == [1, 2]

    hash[:a][:b].should == [1, 2]
  end

  example do
    hash = Hash.nest(1) { [] }
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_an_instance_of(Hash)
    hash.should have_key(:a)

    hash[:a][:b].should == []
    hash[:a].should have_key(:b)

    hash[:a][:b] << 1
    hash[:a][:b].should == [1]

    hash[:a][:c] << 2
    hash[:a][:c].should == [2]

    hash[:a][:b].should == [1]
  end

  example do
    hash = Hash.nest(3)
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_an_instance_of(Hash)
    hash.should have_key(:a)

    hash[:a][:b].should be_an_instance_of(Hash)
    hash[:a].should have_key(:b)

    hash[:a][:b][:c].should be_an_instance_of(Hash)
    hash[:a][:b].should have_key(:c)

    hash[:a][:b][:c][:d].should be_nil
    hash[:a][:b][:c].should have_key(:d)

    hash[:a][:b][:c][:e] = 1
    hash[:a][:b][:c][:e].should == 1
    hash[:a][:b][:c].should have_key(:e)
  end

end
