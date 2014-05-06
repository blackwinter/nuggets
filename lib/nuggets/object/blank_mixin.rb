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
    module BlankMixin

  # call-seq:
  #   object.blank? => +true+ or +false+
  #
  # Basically a short-cut to <tt>object.nil? || object.empty?</tt>.
  def blank?(*modifiers)
    if block_given?
      return true if yield(dup).blank?
    end

    if modifiers.empty?
      respond_to?(:empty?) ? empty? : !self
    else
      return true if blank?

      modifiers.each { |modifier|
        if respond_to?(modifier)
          if modifier.to_s =~ /\?\z/
            return true if send(modifier)
          else
            return true if send(modifier).blank?
          end
        end
      }

      false
    end
  end

  # call-seq:
  #   object.void? => +true+ or +false+
  #
  # Adds white-space strings, 0 and arrays of +nil+ objects to the list of
  # blank objects.
  def void?
    blank?(:zero?, :strip, :compact)
  end
  alias_method :vain?, :void?

    end
  end

  class Array
    module BlankMixin

  # call-seq:
  #   array.vain? => +true+ or +false+
  #
  # Returns +true+ if all of _array_'s elements are themselves vain.
  def vain?
    blank? { |a| a.delete_if { |i| i.vain? } }
  end

    end
  end

  class Hash
    module BlankMixin

  # call-seq:
  #   hash.vain? => +true+ or +false+
  #
  # Returns +true+ if all of _hash_'s values are themselves vain.
  def vain?
    blank? { |h| h.delete_if { |_, v| v.vain? } }
  end

    end
  end
end
