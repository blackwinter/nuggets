require 'nuggets/array/format'

describe Array, 'format' do

  def self.test_format(*f)
    return if RUBY_ENGINE == 'jruby' && JRUBY_VERSION.include?('pre')
    f.pop.each { |x, y| example { (f.dup % x).should == y } }
  end

  test_format('"%s"',
    []       => '',
    'string' => '"string"',
    ''       => ''
  )

  test_format('%s, (%s)', '%s', '(%s)',
    ['place', 'country'] => 'place, (country)',
    ['place', ''       ] => 'place',
    ['',      'country'] => '(country)',
    ['',      ''       ] => ''
  )

  test_format('%s: %s (%s)', '%s: %s', '%s (%s)', '%s (%s)',
    ['author', 'title', 'year'] => 'author: title (year)',
    ['author', 'title', ''    ] => 'author: title',
    ['author', '',      'year'] => 'author (year)',
    ['',       'title', 'year'] => 'title (year)',
    ['author', ''     , ''    ] => 'author',
    ['',       'title', ''    ] => 'title',
    ['',       '',      'year'] => 'year',
    ['',       '',      ''    ] => ''
  )

  test_format({ sep: ':' },
    ['1', '2', '3', '4'] => '1:2:3:4',
    ['1', '2', '3', '' ] => '1:2:3',
    ['1', '2', '',  '4'] => '1:2:4',
    ['1', '',  '3', '4'] => '1:3:4',
    ['',  '2', '3', '4'] => '2:3:4',
    ['1', '2', '',  '' ] => '1:2',
    ['1', '',  '3', '' ] => '1:3',
    ['1', '',  '',  '4'] => '1:4',
    ['',  '2', '3', '' ] => '2:3',
    ['',  '2', '',  '4'] => '2:4',
    ['',  '',  '3', '4'] => '3:4',
    ['1', '',  '',  '' ] => '1',
    ['',  '2', '',  '' ] => '2',
    ['',  '',  '3', '' ] => '3',
    ['',  '',  '',  '4'] => '4',
    ['',  '',  '',  '' ] => ''
  )

end
