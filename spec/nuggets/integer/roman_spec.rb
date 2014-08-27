require 'nuggets/integer/roman'

describe_extended Integer, Nuggets::Integer::RomanMixin do

  {
    1    => 'I',
    2    => 'II',
    3    => 'III',
    4    => 'IV',
    5    => 'V',
    6    => 'VI',
    7    => 'VII',
    8    => 'VIII',
    9    => 'IX',
    10   => 'X',
    13   => 'XIII',
    22   => 'XXII',
    40   => 'XL',
    90   => 'XC',
    207  => 'CCVII',
    1066 => 'MLXVI',
    1666 => 'MDCLXVI',
    1903 => 'MCMIII',
    1910 => 'MCMX',
    1954 => 'MCMLIV',
    1990 => 'MCMXC',
    2014 => 'MMXIV',
    3999 => 'MMMCMXCIX'
  }.each { |int, num|
    example { int.to_roman.should == num }
    example { (-int).to_roman.should == '-' + num }
  }

  example { 0.to_roman.should == 'N' }

end
