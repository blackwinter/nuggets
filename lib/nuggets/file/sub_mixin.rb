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

require 'nuggets/file/replace_mixin'

module Nuggets
  class File
    module SubMixin

  def self.extended(base)
    base.extend Nuggets::File::ReplaceMixin
  end

  # call-seq:
  #   File.sub(name, *args, &block) => aString
  #
  # Calls String#sub! on file +name+'s contents with +args+ and (optional)
  # +block+ and returns the new content.
  def sub(name, *args)
    content = read(name)
    content.sub!(*args, &block_given? ? ::Proc.new : nil)
    content
  end

  # call-seq:
  #   File.sub!(name, *args, &block) => aString or +nil+
  #
  # Calls String#sub! on file +name+'s contents with +args+ and (optional)
  # +block+ and replaces the file with the new content. Returns the result
  # of the String#sub! call.
  def sub!(name, *args)
    res = nil

    replace(name) { |content|
      res = content.sub!(*args, &block_given? ? ::Proc.new : nil)
      content
    }

    res
  end

  # call-seq:
  #   File.gsub(name, *args, &block) => aString
  #
  # Calls String#gsub! on file +name+'s contents with +args+ and (optional)
  # +block+ and returns the new content.
  def gsub(name, *args)
    content = read(name)
    content.gsub!(*args, &block_given? ? ::Proc.new : nil)
    content
  end

  # call-seq:
  #   File.gsub!(name, *args, &block) => aString or +nil+
  #
  # Calls String#gsub! on file +name+'s contents with +args+ and (optional)
  # +block+ and replaces the file with the new content. Returns the result
  # of the String#gsub! call.
  def gsub!(name, *args)
    res = nil

    replace(name) { |content|
      res = content.gsub!(*args, &block_given? ? ::Proc.new : nil)
      content
    }

    res
  end

    end
  end
end
