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

end

if $0 == __FILE__
  o = Object.new
  p o
  p o.singleton_class
end
