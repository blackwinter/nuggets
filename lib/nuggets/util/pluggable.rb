#--
###############################################################################
#                                                                             #
# A component of ruby-nuggets, some extensions to the Ruby programming        #
# language.                                                                   #
#                                                                             #
# Copyright (C) 2007-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
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

module Util

  module Pluggable

    class << self

      def load_plugins_for(*klasses)
        klasses.map { |klass| klass.extend(self).load_plugins }
      end

      def extended(base)
        base.plugin_filename ||= "#{base.name.
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/,     '\1_\2').
          gsub(/::/, '/').tr('-', '_').downcase}_plugin.rb"
      end

    end

    attr_accessor :plugin_filename

    def load_plugins
      plugins, name = [], plugin_filename
      plugins.concat(load_env_plugins(name))
      plugins.concat(load_gem_plugins(name)) if defined?(::Gem)
      plugins
    end

    private

    def load_env_plugins(name)
      load_plugin_files($LOAD_PATH.map { |path|
        plugin = ::File.expand_path(name, path)
        plugin if ::File.file?(plugin)
      }.compact)
    end

    def load_gem_plugins(name)
      load_plugin_files(::Gem::Specification.map { |spec|
        spec.matches_for_glob(name)
      }.flatten)
    end

    def load_plugin_files(plugins)
      plugins.each { |plugin|
        begin
          load plugin
        rescue ::Exception => err
          warn "Error loading #{name} plugin: #{plugin}: #{err} (#{err.class})"
        end
      }
    end

  end

end
