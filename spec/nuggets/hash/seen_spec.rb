require 'nuggets/hash/seen'

describe_extended Hash, Nuggets::Hash::SeenMixin, true do

  example do
    hash = Hash.seen
    hash.should be_an_instance_of(Hash)

    hash[:a].should == false
    hash.should have_key(:a)

    hash[:a].should == true
    hash[:a].should == true
  end

  example do
    hash = Hash.seen(0, 1)
    hash.should be_an_instance_of(Hash)

    hash[:a].should == 1
    hash.should have_key(:a)

    hash[:a].should == 0
    hash[:a].should == 0
  end

  example do
    hash = Hash.seen.update(a: :b)
    hash.should be_an_instance_of(Hash)

    hash[:a].should == :b
    hash[:a].should == :b
    hash.should have_key(:a)
  end

end
