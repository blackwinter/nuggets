require 'nuggets/dotted_decimal'

addr = {
  '77.47.161.3'   => 1294967043,
  '77.47.161.11'  => 1294967051,
  '136.202.107.2' => 2294967042,
  '196.101.53.1'  => 3294967041,
  '255.255.255.0' => 4294967040
}

describe Integer, 'dotted_decimal' do

  addr.each { |s, i| example { i.to_dotted_decimal.should == s } }

end

describe String, 'dotted_decimal' do

  addr.each { |s, i| example { s.from_dotted_decimal.should == i } }

end

describe Array, 'dotted_decimal' do

  example { addr.keys.sort_by_dotted_decimal.should == addr.sort_by { |k, v| v }.map(&:first) }

end
