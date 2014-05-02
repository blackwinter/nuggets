require 'nuggets/array/monotone'

describe Array, 'monotone' do

  example {
    a = [1, 2, 3, 4]

    a.should be_monotonic
    a.should be_ascending
    a.should be_strictly_ascending
    a.should_not be_descending
  }

  example {
    b = [1, 2, 4, 3]

    b.should_not be_monotonic
    b.should_not be_ascending
    b.should_not be_descending
  }

  example {
    c = [1, 2, 4, 4]

    c.should be_monotonic
    c.should be_ascending
    c.should_not be_strictly_ascending
  }

end
