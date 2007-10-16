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

class Hash

  # call-seq:
  #   hash.insert(key, value) => new_hash
  #   hash.insert(key, value) { |old_value, value| ... } => new_hash
  #
  # Inserts +value+ into _hash_ at +key+, while merging existing values at
  # +key+ instead of just overwriting. Uses default Hash#merge or block for
  # merging.
  def insert(key, value, relax = true, &block)
    dup.insert!(key, value, relax, &block) || dup
  end

  # call-seq:
  #   hash.insert!(key, value) => hash
  #   hash.insert!(key, value) { |old_value, value| ... } => hash
  #
  # Destructive version of #insert.
  def insert!(key, value, relax = true, &block)
    block ||= lambda { |old_val, val| old_val.merge(val) }

    self[key] = begin
      block[self[key], value]
    rescue NoMethodError, TypeError => err
      unless relax
        raise err
      else
        value
      end
    end

    self
  end

end

if $0 == __FILE__
  h = { :a => 0, :b => { :b1 => 1, :b2 => 2 } }
  p h

  p h.insert(:a, -1)
  p h.insert(:b, :b3 => 3)

  h.insert!(:b, :b0 => 0)
  p h
end
