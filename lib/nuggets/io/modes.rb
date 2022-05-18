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

class IO

  # Inspired by Martin DeMello, [ruby-talk:307782] -- thx ;-)

  class << self

    alias_method :_nuggets_original_read, :read

    # call-seq:
    #   IO.read(name[, length[, offset]]]) => aString
    #   IO.read(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode +r+. NOTE: With no associated block,
    # acts like the original IO::read, not like IO::new.
    def read(name, *args, **opts, &block)
      return _nuggets_original_read(name, *args, **opts) unless block_given?

      case args.size
        when 0
          # ok
        when 1
          case binary = args.first
            when true, false, nil
              # ok
            else
              raise ::TypeError, "wrong argument type #{binary.class} (expected boolean)"
          end
        else
          raise ::ArgumentError, "wrong number of arguments (#{args.size + 1} for 1-2)"
      end

      open_with_mode(name, 'r', binary, &block)
    end

    # call-seq:
    #   IO.write(name[, binary]) => anIO
    #   IO.write(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode +w+.
    def write(name, binary = false, &block)
      open_with_mode(name, 'w', binary, &block)
    end

    # call-seq:
    #   IO.append(name[, binary]) => anIO
    #   IO.append(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode +a+.
    def append(name, binary = false, &block)
      open_with_mode(name, 'a', binary, &block)
    end

    # call-seq:
    #   IO.read_write(name[, binary]) => anIO
    #   IO.read_write(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode <tt>r+</tt>.
    def read_write(name, binary = false, &block)
      open_with_mode(name, 'r+', binary, &block)
    end

    # call-seq:
    #   IO.write_read(name[, binary]) => anIO
    #   IO.write_read(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode <tt>w+</tt>.
    def write_read(name, binary = false, &block)
      open_with_mode(name, 'w+', binary, &block)
    end

    # call-seq:
    #   IO.append_read(name[, binary]) => anIO
    #   IO.append_read(name[, binary]) { |io| ... } => anObject
    #
    # Opens +name+ with mode <tt>a+</tt>.
    def append_read(name, binary = false, &block)
      open_with_mode(name, 'a+', binary, &block)
    end

    private

    # Just a helper to DRY things up.
    def open_with_mode(name, mode, binary = false, &block)
      open(name, "#{mode}#{'b' if binary}", &block)
    end

  end

end

if $0 == __FILE__
  # ::File.read(__FILE__) { |f| ... }
  # ::File.write(__FILE__) { |f| ... }
  # ::File.append(__FILE__) { |f| ... }
end
