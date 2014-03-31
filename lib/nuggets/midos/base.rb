# encoding: utf-8

#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2014 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# ruby-nuggets is free software; you can redistribute it and/or modify it     #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# ruby-nuggets is distributed in the hope that it will be useful, but WITHOUT #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with ruby-nuggets. If not, see <http://www.gnu.org/licenses/>.        #
#                                                                             #
###############################################################################
#++

module Nuggets
  module Midos
    class Base

  class << self

    private

    def file_method(method, mode, file, options = {}, *args, &block)
      Midos.open_file(file, options, mode) { |io|
        args.unshift(options.merge(:io => io))
        method ? send(method, *args, &block) : block[new(*args)]
      }
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

  end

  def initialize(options = {}, &block)
    self.key = options[:key]

    self.rs = options[:rs] || DEFAULT_RS
    self.fs = options[:fs] || DEFAULT_FS
    self.vs = options[:vs] || DEFAULT_VS
    self.nl = options[:nl] || DEFAULT_NL
    self.le = options[:le] || DEFAULT_LE
    self.io = options[:io] || self.class::DEFAULT_IO

    @auto_id_block = options[:auto_id] || block
    reset
  end

  attr_accessor :key, :rs, :fs, :nl, :le, :io, :auto_id

  attr_reader :vs

  def reset
    @auto_id = @auto_id_block ? @auto_id_block.call : default_auto_id
  end

  private

  def default_auto_id(n = 0)
    lambda { n += 1 }
  end

    end
  end
end
