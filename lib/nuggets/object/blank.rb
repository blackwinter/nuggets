#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007 Jens Wille                                               #
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
  #   object.blank? => true or false
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
        next unless respond_to?(modifier)

        if modifier.to_s[-1] == ??
          return true if send(modifier)
        else
          return true if send(modifier).blank?
        end
      }

      false
    end
  end

  # call-seq:
  #   object.void? => true or false
  #
  # Adds white-space strings, 0 and arrays of +nil+ objects to the list of
  # blank objects.
  def void?
    blank?(:zero?, :strip, :compact)
  end
  alias_method :vain?, :void?

end

class Array

  # call-seq:
  #   array.vain? => true or false
  #
  # Returns true if any of _array_'s elements are themselves vain.
  def vain?
    blank? { |a| a.delete_if { |i| i.vain? } }
  end

end

class Hash

  # call-seq:
  #   hash.vain? => true or false
  #
  # Returns true if any of _hash_'s values are themselves vain.
  def vain?
    blank? { |h| h.delete_if { |k, v| v.vain? } }
  end

end

if $0 == __FILE__
  ['', ' ', 's', 0, 1, nil, true, false, [], [nil], {}].each { |o|
    p o
    p o.blank?
    p o.void?
  }

  o = ['', [], [nil], {}]
  p o
  p o.blank?
  p o.void?
  p o.vain?

  o = { :x => nil, :y => [], :z => { :zz => nil } }
  p o
  p o.blank?
  p o.void?
  p o.vain?
end