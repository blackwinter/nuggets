require 'nuggets/file/ext'

describe_extended File, Nuggets::File::ExtMixin, true do

  [
    ['foo', nil, '.baz'],
    %w[foo.bar foo .baz],
    %w[foo.bar.baz foo.bar .baz]
  ].each { |path, new_path, new_ext|
    example {
      File.chomp_ext(path).should  == (new_path || path)
    }

    example {
      File.chomp_ext!(_path = path.dup).should == new_path
      _path.should == (new_path || path)
    }

    example {
      File.sub_ext(path, new_ext).should == (new_path ? "#{new_path}#{new_ext}" : path)
    }

    example {
      File.sub_ext!(_path = path.dup, new_ext).should == (new_path && "#{new_path}#{new_ext}")
      _path.should == (new_path ? "#{new_path}#{new_ext}" : path)
    }

    example {
      File.set_ext(path, new_ext).should == "#{new_path || path}#{new_ext}"
    }

    example {
      File.set_ext!(_path = path.dup, new_ext).should == "#{new_path || path}#{new_ext}"
      _path.should == "#{new_path || path}#{new_ext}"
    }
  }

end
