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

require 'set'

module Nuggets
  module Pluggable

    def self.load_plugins_for(*klasses)
      klasses.map { |klass| klass.extend(self).load_plugins }
    end

    def load_plugins(name = plugin_filename)
      load_path_plugins(name)
      load_gem_plugins(name)
      load_env_plugins(name)

      loaded_plugins.to_a
    end

    def loaded_plugins
      @loaded_plugins ||= Set.new
    end

    def plugin_filename
      @plugin_filename ||= "#{name.
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/,     '\1_\2').
        gsub(/::/, '/').tr('-', '_').downcase}_plugin.rb"
    end

    attr_writer :plugin_filename

    private

    def load_path_plugins(name)
      $LOAD_PATH.dup.each { |path|
        plugin = ::File.expand_path(name, path)
        load_plugin_file(plugin) if ::File.file?(plugin)
      }
    end

    def load_gem_plugins(name)
      ::Gem::Specification.latest_specs.each { |spec|
        load_plugin_files(spec.matches_for_glob(name))
      } if ::Object.const_defined?(:Gem)
    end

    def load_env_plugins(name)
      path = ::ENV["#{name.chomp(ext = ::File.extname(name)).upcase}_PATH"]
      path.split(::File::PATH_SEPARATOR).each { |dir|
        load_plugin_files(::Dir["#{dir}/*#{ext}"])
      } if path
    end

    def load_plugin_file(plugin)
      load plugin if loaded_plugins.add?(plugin)
    rescue ::Exception => err
      raise unless loaded_plugins.delete?(plugin)
      warn "Error loading #{name} plugin: #{plugin}: #{err} (#{err.class})"
    end

    def load_plugin_files(plugins)
      plugins.each { |plugin| load_plugin_file(::File.expand_path(plugin)) }
    end

  end
end
