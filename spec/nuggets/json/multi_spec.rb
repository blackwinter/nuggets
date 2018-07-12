require 'nuggets/json/multi'

describe_extended JSON, Nuggets::JSON::MultiMixin, true do

  let(:source) { '{"a":1,"b":[42,23],"a":{"b":2}}' }

  describe 'plain' do

    subject { JSON.parse(source) }

    example { expect(subject).to be_a(Hash) }
    example { expect(subject.size).to eq(2) }
    example { expect(subject.keys).to eq(%w[a b]) }

    example { expect(subject['a']).to eq('b' => 2) }
    example { expect(subject['b']).to eq([42, 23]) }

    example { expect(JSON.pretty_generate(subject)).to eq(<<-EOT.chomp) }
{
  "a": {
    "b": 2
  },
  "b": [
    42,
    23
  ]
}
    EOT

  end

  describe 'multi' do

    subject { JSON.parse_multi(source) }

    let(:multi) { subject.fetch_multi('a') }

    let(:pretty) { <<-EOT.chomp }
{
  "a": 1,
  "b": [
    42,
    23
  ],
  "a": {
    "b": 2
  }
}
    EOT

    example { expect(subject).to be_a(Hash) }
    example { expect(subject.size).to eq(3) }
    example { expect(subject.keys).to eq(%w[a b a]) }

    example { expect(subject['a']).to eq(1) }
    example { expect(subject['b']).to eq([42, 23]) }

    example { expect(multi[0]).to eq(1) }
    example { expect(multi[1]).to be_a(Hash) }
    example { expect(multi[1]['b']).to eq(2) }

    example { expect(JSON.pretty_generate(subject)).to eq(pretty) }
    example { expect(JSON.pretty_print_multi(source)).to eq(pretty) }

  end

end
