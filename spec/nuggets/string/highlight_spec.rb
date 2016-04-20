require 'nuggets/string/highlight'

describe_extended String, Nuggets::String::HighlightMixin do

unless RUBY_ENGINE == 'jruby' && JRUBY_VERSION.include?('pre')

  example do
    s = 'lingo go do the go go'; t = s.dup
    expect(s.highlight('lingo')).to eq('|lingo| go do the go go')
    expect(s).to eq(t)

    expect(s.highlight(/lingo/)).to eq('|lingo| go do the go go')
    expect(s.highlight(/l.*ngo?/)).to eq('|lingo| go do the go go')

    q = ['lingo', 'go', 'go go']
    expect(s.highlight(q)).to eq('|lingo go| do the |go go|')
  end

  example do
    s = 'lingö go do the go go'
    q = ['lingö', 'go', 'go go']
    expect(s.highlight(q)).to eq('|lingö| |go| do the |go go|')
  end

  example do
    s = 'lingo go do the go go'
    q = ['lingo', 'go', 'go go']
    expect(s.highlight(q, '^')).to eq('^lingo go^ do the ^go go^')
    expect(s.highlight(q, '<', '>')).to eq('<lingo go> do the <go go>')
    expect(s.highlight(q, '<i>', '</i>')).to eq('<i>lingo go</i> do the <i>go go</i>')
  end

  example do
    s = 'The fox went out on a chilly night'
    q = [/[eo]n/]
    expect(s.highlight(q)).to eq('The fox w|en|t out |on| a chilly night')
    q << 'went'
    expect(s.highlight(q)).to eq('The fox |went| out |on| a chilly night')
    q << /ou.*a/
    expect(s.highlight(q)).to eq('The fox |went| |out on a| chilly night')
    q << 'went out'
    expect(s.highlight(q)).to eq('The fox |went out on a| chilly night')
  end

end

end
