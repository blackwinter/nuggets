require 'nuggets/array/extract_options'

describe_extended Array, Nuggets::Array::ExtractOptionsMixin do

  example { expect([].extract_options).to eq({}) }

  example { expect([].extract_options(42)).to eq(42) }

  example { expect([].extract_options(nil)).to eq(nil) }

  example { expect([42].extract_options).to eq({}) }

  example { expect([foo: 42].extract_options).to eq(foo: 42) }

  example { expect([23, foo: 42].extract_options).to eq(foo: 42) }

  example { expect([{ foo: 42 }, 23].extract_options).to eq({}) }

  example { expect([23, 42, {}].extract_options).to eq({}) }

  example { expect([23, 42, {}].extract_options(nil)).to eq({}) }

  example { expect([23, 42].extract_options).to eq({}) }

  example { expect([23, 42].extract_options(nil)).to eq(nil) }

  example {
    a = [23, foo: 42]

    expect(a.extract_options).to eq(foo: 42)
    expect(a).to eq([23, foo: 42])

    expect(a.extract_options!).to eq(foo: 42)
    expect(a).to eq([23])
  }

  example {
    a = [{ foo: 42 }, 23]

    expect(a.extract_options).to eq({})
    expect(a).to eq([{ foo: 42 }, 23])

    expect(a.extract_options!).to eq({})
    expect(a).to eq([{ foo: 42 }, 23])
  }

end
