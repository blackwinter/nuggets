require 'nuggets/enumerable/all_any_extended_mixin'

[Array, Hash, IO, Range].each { |klass|
  klass.send klass.respond_to?(:prepend) ? :prepend : :include, Nuggets::Enumerable::AllAnyExtendedMixin
}
