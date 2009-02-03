require 'nuggets/object/blank_mixin'

class Object
  include Nuggets::Object::BlankMixin
end

class Array
  include Nuggets::Array::BlankMixin
end

class Hash
  include Nuggets::Hash::BlankMixin
end

#class String
#  if public_instance_methods(false).include?(method = 'blank?')
#    # remove incompatible implementation added by utility_belt/language_greps.rb
#    remove_method method
#  end
#end
