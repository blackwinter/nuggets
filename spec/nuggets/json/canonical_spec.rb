require 'nuggets/json/canonical'
require 'nuggets/json/multi'

describe_extended JSON, Nuggets::JSON::CanonicalMixin, true do

  let(:source) { '{"a":1,"b":[42,23],"a":{"b":2,"a":[3,5,4]}}' }

  subject { JSON.parse(source) }

  describe 'plain' do

    example { expect(JSON.generate(subject)).to eq('{"a":{"b":2,"a":[3,5,4]},"b":[42,23]}') }

    example { expect(JSON.pretty_generate(subject)).to eq(<<-EOT.chomp) }
{
  "a": {
    "b": 2,
    "a": [
      3,
      5,
      4
    ]
  },
  "b": [
    42,
    23
  ]
}
    EOT

  end

  describe 'canonical' do

    example { expect(JSON.generate_canonical(subject)).to eq('{"a":{"a":[3,4,5],"b":2},"b":[23,42]}') }

    example { expect(JSON.pretty_generate_canonical(subject)).to eq(<<-EOT.chomp) }
{
  "a": {
    "a": [
      3,
      4,
      5
    ],
    "b": 2
  },
  "b": [
    23,
    42
  ]
}
    EOT

    example { expect(JSON.pretty_print_canonical(source)).to eq(<<-EOT.chomp) }
{
  "a": 1,
  "a": {
    "a": [
      3,
      4,
      5
    ],
    "b": 2
  },
  "b": [
    23,
    42
  ]
}
    EOT

  end

end
