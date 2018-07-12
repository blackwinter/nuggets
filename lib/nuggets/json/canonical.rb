require 'json'

require_relative 'canonical_mixin'

JSON.extend(Nuggets::JSON::CanonicalMixin)
