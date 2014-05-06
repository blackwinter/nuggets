#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# nuggets is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# nuggets is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with nuggets. If not, see <http://www.gnu.org/licenses/>.             #
#                                                                             #
###############################################################################
#++

module Nuggets
  class Object
    module SingletonClassMixin

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
    [true, false, nil].each { |obj|
      return obj if self.equal?(obj.singleton_class)
    }

    # raises TypeError if neither class nor module
    ::ObjectSpace.each_object(self) { |obj|
      return obj if self.equal?(obj.singleton_class)
    }

    # if we got here, it can't be a singleton class
    # or its singleton object doesn't exist anymore
    raise ::TypeError
  rescue ::TypeError
    raise ::TypeError, 'not a singleton class'
  end

  alias_method :virtual_object, :singleton_object
  alias_method :ghost_object,   :singleton_object
  alias_method :eigenobject,    :singleton_object
  alias_method :metaobject,     :singleton_object
  alias_method :uniobject,      :singleton_object

  alias_method :singleton_instance, :singleton_object

  # call-seq:
  #   object.singleton_class? => +true+ or +false+
  #
  # Returns +true+ if _object_ is a singleton_class
  # (i.e., has a singleton_object), +false+ otherwise.
  def singleton_class?
    singleton_object
    true
  rescue ::TypeError
    false
  end

  alias_method :virtual_class?, :singleton_class?
  alias_method :ghost_class?,   :singleton_class?
  alias_method :eigenclass?,    :singleton_class?
  alias_method :metaclass?,     :singleton_class?
  alias_method :uniclass?,      :singleton_class?

    end
  end
end
