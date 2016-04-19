require 'nuggets/string/format'

describe_extended String, Nuggets::String::FormatMixin do

  example do
    expect{'a%bc'.format}.to raise_error(ArgumentError, 'wrong number of arguments (given 0, expected 1)')
  end

  example do
    expect('a%bc'.format('b' => 'foo')).to eq('afooc')
  end

  example do
    expect('a%bc'.format(b: 'foo')).to eq('afooc')
  end

  example do
    expect('a%bc'.format(b: :foo)).to eq('afooc')
  end

  example do
    expect('a%bc'.format(b: 42)).to eq('a42c')
  end

  example do
    expect('a%bc'.format(b: '')).to eq('ac')
  end

  example do
    expect('a%bc'.format(b: nil)).to eq('ac')
  end

  example do
    expect('a%{foo}c'.format('foo' => 'bar')).to eq('abarc')
  end

  example do
    expect('a%{foo}c'.format(foo: 'bar')).to eq('abarc')
  end

  example do
    expect('a%{foo}c'.format(foo: :bar)).to eq('abarc')
  end

  example do
    expect(''.format({})).to eq('')
  end

  example do
    expect('%'.format({})).to eq('%')
  end

  example do
    expect('%%'.format({})).to eq('%')
  end

  example do
    expect{'%a'.format({})}.to raise_error(KeyError, 'key not found: a')
  end

  example do
    expect{'%a'.format('b' => 'foo')}.to raise_error(KeyError, 'key not found: a')
  end

  example do
    expect{'%a'.format(Hash.new(42))}.to raise_error(KeyError, 'key not found: a')
  end

  example do
    expect('a%bc'.format(&:upcase)).to eq('aBc')
  end

  example do
    expect('a%bc'.format{''}).to eq('ac')
  end

  example do
    expect{'a%bc'.format{}}.to raise_error(ArgumentError, 'malformed format string - %b')
  end

  example do
    expect('a%bc%d%{foo}%%{baz}'.format(b: 42, d: 'D', 'foo' => :bar)).to eq('a42cDbar%{baz}')
  end

end
