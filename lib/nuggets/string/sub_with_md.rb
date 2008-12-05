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

class String

  alias_method :sub_without_md,   :sub
  alias_method :sub_without_md!,  :sub!
  alias_method :gsub_without_md,  :gsub
  alias_method :gsub_without_md!, :gsub!

  # call-seq:
  #   str.sub_with_md(pattern) { |match_data| ... } => new_str
  #
  # Just like #sub, but passes the MatchData object instead of the current
  # match string to the block.
  def sub_with_md(pattern, replacement = nil)
    replacement ?
      sub_without_md(pattern, replacement) :
      (_dup = dup).sub_with_md!(pattern) { |*a| yield(*a) } || _dup
  end

  # call-seq:
  #   str.sub_with_md!(pattern) { |match_data| ... } => str or nil
  #
  # Destructive version of #sub_with_md.
  def sub_with_md!(pattern, replacement = nil)
    replacement ?
      sub_without_md!(pattern, replacement) :
      sub_without_md!(pattern) { |match| yield $~ }
  end

  # call-seq:
  #   str.gsub_with_md(pattern) { |match_data| ... } => new_str
  #
  # Just like #gsub, but passes the MatchData object instead of the current
  # match string to the block.
  def gsub_with_md(pattern, replacement = nil)
    replacement ?
      gsub_without_md(pattern, replacement) :
      (_dup = dup).gsub_with_md!(pattern) { |*a| yield(*a) } || _dup
  end

  # call-seq:
  #   str.gsub_with_md!(pattern) { |match_data| ... } => str or nil
  #
  # Destructive version of #gsub_with_md.
  def gsub_with_md!(pattern, replacement = nil)
    replacement ?
      gsub_without_md!(pattern, replacement) :
      gsub_without_md!(pattern) { |match| yield $~ }
  end

  # call-seq:
  #   gimme_match_data!
  #
  # Replaces the traditional substitution methods with their MatchData passing
  # equivalents. USE WITH CAUTION!
  def self.gimme_match_data!
    alias_method :sub,   :sub_with_md
    alias_method :sub!,  :sub_with_md!
    alias_method :gsub,  :gsub_with_md
    alias_method :gsub!, :gsub_with_md!
  end

end

if $0 == __FILE__
  # stupid example, but it proves the point ;-)
  s = 'Foo, Bar - Baz'
  p s

  p s.gsub(/\w(\w+)(\W*)/) { |m|
    #p m
    "#{$1.gsub(/[ao]/, 'X')}#{$2}"
  }

  p s.gsub_with_md(/\w(\w+)(\W*)/) { |md|
    #p md[0]
    "#{md[1].gsub(/[ao]/, 'X')}#{md[2]}"
  }

  p s.gsub_with_md(/\w(\w+)(\W*)/) { |md|
    #p md[0]
    "#{md[1].gsub_with_md(/[ao]/) { |md2| md2[0].upcase }}#{md[2]}"
  }

  String.gimme_match_data!

  p s.gsub(/\w(\w+)(\W*)/) { |m|
    #p m
    begin
      "#{$1.gsub(/[ao]/, 'X')}#{$2}"
    rescue NoMethodError => err
      warn err
    end
  }

  p s.gsub(/\w(\w+)(\W*)/) { |md|
    #p md[0]
    "#{md[1].gsub(/[ao]/, 'X')}#{md[2]}"
  }

  p s.gsub(/\w(\w+)(\W*)/) { |md|
    #p md[0]
    "#{md[1].gsub(/[ao]/) { |md2| md2[0].upcase }}#{md[2]}"
  }
end
