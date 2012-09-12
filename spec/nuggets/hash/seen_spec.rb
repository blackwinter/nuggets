require 'nuggets/hash/seen'

describe Hash, 'when extended by', Nuggets::Hash::SeenMixin do

  it { (class << Hash; self; end).ancestors.should include(Nuggets::Hash::SeenMixin) }

  example do
    hash = Hash.seen
    hash.should be_an_instance_of(Hash)

    hash[:a].should be_false
    hash.should have_key(:a)

    hash[:a].should be_true
    hash[:a].should be_true
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
    hash = Hash.seen.update(:a => :b)
    hash.should be_an_instance_of(Hash)

    hash[:a].should == :b
    hash[:a].should == :b
    hash.should have_key(:a)
  end

end
