require 'nuggets/file/which'

describe_extended File, Nuggets::File::WhichMixin, true do

  %w[cat dog rat gcc /usr/bin/X11/gcc].each { |c|
    example do
      r = %x{which #{c}}.chomp
      File.which(c).should == (r.empty? ? nil : r)
    end
  }

  example do
    c = [
      'unison --args source target',
      'rsync --args source target',
      'scp --args source target'
    ]
    r = c.find { |s| !%x{which #{s[/\S+/]}}.chomp.empty? }
    File.which_command(c).should == r
  end

end
