#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2008 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# ruby-nuggets is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for    #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.              #
#                                                                             #
###############################################################################
#++

class Object

  # call-seq:
  #   object.singleton_class => aClass
  #
  # Returns the singleton (or virtual/eigen/meta) class associated with _object_.
  def singleton_class
    class << self; self; end
  end

  alias_method :virtual_class, :singleton_class
  alias_method :ghost_class,   :singleton_class
  alias_method :eigenclass,    :singleton_class
  alias_method :metaclass,     :singleton_class
  alias_method :uniclass,      :singleton_class

  # call-seq:
  #   object.singleton_object => anObject
  #
  # Returns the object of which _object_ is the singleton_class.
  # Raises a TypeError if _object_ is not a singleton class.
  def singleton_object
    object = ObjectSpace.each_object(self) { |obj| break obj }
    raise TypeError unless self.equal?(object.singleton_class)
    object
  rescue TypeError
    raise TypeError, 'not a singleton class'
  end

  alias_method :virtual_object, :singleton_object
  alias_method :ghost_object,   :singleton_object
  alias_method :eigenobject,    :singleton_object
  alias_method :metaobject,     :singleton_object
  alias_method :uniobject,      :singleton_object

  # call-seq:
  #   object.singleton_class? => true or false
  #
  # Returns true if _object_ is a singleton_class
  # (i.e., has a singleton_object), false otherwise.
  def singleton_class?
    singleton_object
    true
  rescue TypeError
    false
  end

  alias_method :virtual_class?, :singleton_class?
  alias_method :ghost_class?,   :singleton_class?
  alias_method :eigenclass?,    :singleton_class?
  alias_method :metaclass?,     :singleton_class?
  alias_method :uniclass?,      :singleton_class?

end

if $0 == __FILE__
  o = Object.new
  p o
  p o.singleton_class?

  begin
    p o.singleton_object
  rescue TypeError => err
    warn err
  end

  s = o.singleton_class
  p s
  p s.singleton_class?
  p s.singleton_object

  o = [1, 2]
  p o

  s = o.singleton_class
  p s
  p s.singleton_class?
  p s.singleton_object

  p Class.new.singleton_class?
  p Class.singleton_class?

  c = Class.new
  o = c.new
  p o
  p c.singleton_class?

  p nil.singleton_class
  p NilClass.singleton_class?
  p NilClass.singleton_object  # raises TypeError
end
