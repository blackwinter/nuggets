class Array

  # call-seq:
  #   array.flatten_once => new_array
  #
  # Flatten _array_ by _one_ level only.
  def flatten_once
    inject([]) { |flat, element|
      case element
        when Array
          flat + element
        else
          flat << element
      end
    }
  end

  # call-seq:
  #   array.flatten_once! => array
  #
  # Destructive version of #flatten_once.
  def flatten_once!
    replace flatten_once
  end

end

if $0 == __FILE__
  a = [1, 2, [3, 4, 5], 6, [7, [8, 9]]]
  p a

  p a.flatten
  p a.flatten_once

  a.flatten_once!
  p a
end
