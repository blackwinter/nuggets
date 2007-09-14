class Object

  # call-seq:
  #   object.singleton_class => aClass
  #
  # Returns the singleton class associated with _object_.
  def singleton_class
    class << self; self; end
  end
  alias_method :eigenclass, :singleton_class
  alias_method :metaclass,  :singleton_class

end

if $0 == __FILE__
  o = Object.new
  p o
  p o.singleton_class
end
