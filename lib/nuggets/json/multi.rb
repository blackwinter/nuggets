require 'json'

require_relative 'multi_mixin'

JSON.extend(Nuggets::JSON::MultiMixin)
