#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
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

require 'nuggets/object/lazy_attr'

module Nuggets
  class Module
    module LazyAttrMixin

  def lazy_accessor(name, options = {}, &block)
    attr_writer(attr = lazy_name(name, options))
    lazy_reader(name, options, attr, &block)
  end

  def lazy_reader(name, options = {}, attr = lazy_name(name, options), &block)
    define_method(name) { lazy_attr(attr,
      options.fetch(:freeze, true), &block) }
  end

  alias_method :lazy_attr, :lazy_reader

  private

  def lazy_name(name, options)
    options.fetch(:name) { name.to_s.sub(/\?\z/, '_p') }
  end

    end
  end
end
