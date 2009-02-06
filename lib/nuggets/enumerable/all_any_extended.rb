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

module Enumerable

  alias_method :_nuggets_original_all?, :all?
  alias_method :_nuggets_original_any?, :any?

  # call-seq:
  #   enum.all?(obj[, operator]) => true or false
  #   enum.all? { ... } => true or false
  #
  # Adds the ability to pass an +object+ instead of a block, which will then
  # be tested against each item in _enum_ according to +operator+, defaulting
  # to :===.
  def all?(object = default = Object.new, operator = :===, &block)
    _nuggets_original_all?(&_block_for_all_any_extended(object, default, operator, &block))
  end

  # call-seq:
  #   enum.any?(obj[, operator]) => true or false
  #   enum.any? { ... } => true or false
  #
  # Adds the ability to pass an +object+ instead of a block, which will then
  # be tested against each item in _enum_ according to +operator+, defaulting
  # to :===.
  def any?(object = default = Object.new, operator = :===, &block)
    _nuggets_original_any?(&_block_for_all_any_extended(object, default, operator, &block))
  end

  private

  # Common argument processing for extended versions of #all? and #any?.
  def _block_for_all_any_extended(object, default, operator, &block)
    if default.nil?
      raise ArgumentError, "both block and object argument given", caller(1) if block
      lambda { |*a| object.send(operator, *a) }
    else
      block
    end
  end

end

if $0 == __FILE__
  e = %w[quux quuux quix]
  p e

  p e.all?(String)
  p e.any?(Numeric)

  e = [:one, 'c', nil, 88]
  p e

  p e.all?(Object)
  p e.any?(NilClass)

  begin
    e.any?(NilClass) { |i| i.nil? }
  rescue ArgumentError => err
    puts "#{err.backtrace.first}: #{err} (#{err.class})"
  end

  e = [0, 10, 20]
  p e

  p e.any?(9..99)
  p e.any?(9, :<)
  p e.any? { |i| i < 9 }
end
