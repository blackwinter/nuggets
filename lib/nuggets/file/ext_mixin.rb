#--
###############################################################################
#                                                                             #
# nuggets -- Extending Ruby                                                   #
#                                                                             #
# Copyright (C) 2007-2012 Jens Wille                                          #
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
  class File
    module ExtMixin

      # call-seq:
      #   File.chomp_ext(path) -> aString
      #
      # Returns a copy of +path+ with its file extension removed.
      def chomp_ext(path, ext = extname(path))
        path.chomp(ext)
      end

      # call-seq:
      #   File.chomp_ext!(path) -> aString | nil
      #
      # Modifies +path+ in place as described for #chomp_ext, returning
      # +path+, or +nil+ if no modifications were made.
      def chomp_ext!(path, ext = extname(path))
        path.chomp!(ext)
      end

      # call-seq:
      #   File.sub_ext(path, new_ext) -> aString
      #
      # Returns a copy of +path+ with its file extension replaced
      # with +new_ext+ (if present; see also #set_ext).
      def sub_ext(path, new_ext, ext = extname(path))
        sub_ext!(_path = path.dup, new_ext, ext); _path
      end

      # call-seq:
      #   File.sub_ext!(path, new_ext) -> aString | nil
      #
      # Modifies +path+ in place as described for #sub_ext, returning
      # +path+, or +nil+ if no modifications were made.
      def sub_ext!(path, new_ext, ext = extname(path))
        path << new_ext if chomp_ext!(path, ext)
      end

      # call-seq:
      #   File.set_ext(path, new_ext) -> aString
      #
      # Returns a copy of +path+ with its file extension removed
      # and +new_ext+ appended. Like #sub_ext, but also applies
      # when file extension is not present.
      def set_ext(path, new_ext, ext = extname(path))
        chomp_ext(path, ext) << new_ext
      end

      # call-seq:
      #   File.set_ext!(path, new_ext) -> aString
      #
      # Modifies +path+ in place as described for #set_ext, returning
      # +path+.
      def set_ext!(path, new_ext, ext = extname(path))
        chomp_ext!(path, ext); path << new_ext
      end

    end
  end
end
