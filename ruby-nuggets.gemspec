# -*- encoding: utf-8 -*-
# stub: ruby-nuggets 0.9.8 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-nuggets"
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-04-14"
  s.description = "Some extensions to the Ruby programming language."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = [".rspec", "COPYING", "ChangeLog", "README", "Rakefile", "lib/nuggets.rb", "lib/nuggets/all.rb", "lib/nuggets/all_mixins.rb", "lib/nuggets/ansicolor2css.rb", "lib/nuggets/argv/option.rb", "lib/nuggets/argv/option_mixin.rb", "lib/nuggets/array/boost.rb", "lib/nuggets/array/boost_mixin.rb", "lib/nuggets/array/combination.rb", "lib/nuggets/array/correlation.rb", "lib/nuggets/array/correlation_mixin.rb", "lib/nuggets/array/flatten_once.rb", "lib/nuggets/array/flush.rb", "lib/nuggets/array/flush_mixin.rb", "lib/nuggets/array/format.rb", "lib/nuggets/array/hashify.rb", "lib/nuggets/array/hashify_mixin.rb", "lib/nuggets/array/histogram.rb", "lib/nuggets/array/histogram_mixin.rb", "lib/nuggets/array/in_order.rb", "lib/nuggets/array/limit.rb", "lib/nuggets/array/limit_mixin.rb", "lib/nuggets/array/mean.rb", "lib/nuggets/array/mean_mixin.rb", "lib/nuggets/array/median.rb", "lib/nuggets/array/median_mixin.rb", "lib/nuggets/array/mode.rb", "lib/nuggets/array/mode_mixin.rb", "lib/nuggets/array/monotone.rb", "lib/nuggets/array/only.rb", "lib/nuggets/array/rand.rb", "lib/nuggets/array/regression.rb", "lib/nuggets/array/regression_mixin.rb", "lib/nuggets/array/runiq.rb", "lib/nuggets/array/runiq_mixin.rb", "lib/nuggets/array/shuffle.rb", "lib/nuggets/array/standard_deviation.rb", "lib/nuggets/array/standard_deviation_mixin.rb", "lib/nuggets/array/to_hash.rb", "lib/nuggets/array/variance.rb", "lib/nuggets/array/variance_mixin.rb", "lib/nuggets/cli.rb", "lib/nuggets/content_type.rb", "lib/nuggets/dotted_decimal.rb", "lib/nuggets/enumerable/agrep.rb", "lib/nuggets/enumerable/all_any_extended.rb", "lib/nuggets/enumerable/minmax.rb", "lib/nuggets/env/set.rb", "lib/nuggets/env/set_mixin.rb", "lib/nuggets/env/user_encoding.rb", "lib/nuggets/env/user_encoding_mixin.rb", "lib/nuggets/env/user_home.rb", "lib/nuggets/env/user_home_mixin.rb", "lib/nuggets/file/ext.rb", "lib/nuggets/file/ext_mixin.rb", "lib/nuggets/file/replace.rb", "lib/nuggets/file/replace_mixin.rb", "lib/nuggets/file/sub.rb", "lib/nuggets/file/sub_mixin.rb", "lib/nuggets/file/which.rb", "lib/nuggets/file/which_mixin.rb", "lib/nuggets/hash/at.rb", "lib/nuggets/hash/deep_merge.rb", "lib/nuggets/hash/deep_merge_mixin.rb", "lib/nuggets/hash/idmap.rb", "lib/nuggets/hash/idmap_mixin.rb", "lib/nuggets/hash/in_order.rb", "lib/nuggets/hash/insert.rb", "lib/nuggets/hash/nest.rb", "lib/nuggets/hash/nest_mixin.rb", "lib/nuggets/hash/only.rb", "lib/nuggets/hash/seen.rb", "lib/nuggets/hash/seen_mixin.rb", "lib/nuggets/hash/unroll.rb", "lib/nuggets/hash/unroll_mixin.rb", "lib/nuggets/hash/zip.rb", "lib/nuggets/hash/zip_mixin.rb", "lib/nuggets/i18n.rb", "lib/nuggets/integer/factorial.rb", "lib/nuggets/integer/length.rb", "lib/nuggets/integer/length_mixin.rb", "lib/nuggets/integer/map.rb", "lib/nuggets/integer/map_mixin.rb", "lib/nuggets/integer/to_binary_s.rb", "lib/nuggets/io/agrep.rb", "lib/nuggets/io/interact.rb", "lib/nuggets/io/interact_mixin.rb", "lib/nuggets/io/modes.rb", "lib/nuggets/io/null.rb", "lib/nuggets/io/null_mixin.rb", "lib/nuggets/io/redirect.rb", "lib/nuggets/io/redirect_mixin.rb", "lib/nuggets/lazy_attr.rb", "lib/nuggets/log_parser.rb", "lib/nuggets/log_parser/apache.rb", "lib/nuggets/log_parser/rails.rb", "lib/nuggets/lsi.rb", "lib/nuggets/midos.rb", "lib/nuggets/mysql.rb", "lib/nuggets/net/success.rb", "lib/nuggets/numeric/between.rb", "lib/nuggets/numeric/duration.rb", "lib/nuggets/numeric/limit.rb", "lib/nuggets/numeric/signum.rb", "lib/nuggets/numeric/to_multiple.rb", "lib/nuggets/object/blank.rb", "lib/nuggets/object/blank_mixin.rb", "lib/nuggets/object/boolean.rb", "lib/nuggets/object/boolean_mixin.rb", "lib/nuggets/object/eigenclass.rb", "lib/nuggets/object/ghost_class.rb", "lib/nuggets/object/metaclass.rb", "lib/nuggets/object/msend.rb", "lib/nuggets/object/msend_mixin.rb", "lib/nuggets/object/silence.rb", "lib/nuggets/object/silence_mixin.rb", "lib/nuggets/object/singleton_class.rb", "lib/nuggets/object/singleton_class_mixin.rb", "lib/nuggets/object/uniclass.rb", "lib/nuggets/object/virtual_class.rb", "lib/nuggets/pluggable.rb", "lib/nuggets/proc/bind.rb", "lib/nuggets/proc/bind_mixin.rb", "lib/nuggets/range/quantile.rb", "lib/nuggets/range/quantile_mixin.rb", "lib/nuggets/rdf/compression.rb", "lib/nuggets/rdf/prefix.rb", "lib/nuggets/rdf/turtle.rb", "lib/nuggets/rdf/turtle/reader.rb", "lib/nuggets/rdf/uri.rb", "lib/nuggets/ruby.rb", "lib/nuggets/statistics.rb", "lib/nuggets/statistics_mixins.rb", "lib/nuggets/string/camelscore.rb", "lib/nuggets/string/camelscore_mixin.rb", "lib/nuggets/string/capitalize_first.rb", "lib/nuggets/string/case.rb", "lib/nuggets/string/evaluate.rb", "lib/nuggets/string/evaluate_mixin.rb", "lib/nuggets/string/msub.rb", "lib/nuggets/string/nsub.rb", "lib/nuggets/string/sub_with_md.rb", "lib/nuggets/string/wc.rb", "lib/nuggets/string/wc_mixin.rb", "lib/nuggets/string/word_wrap.rb", "lib/nuggets/string/xor.rb", "lib/nuggets/string/xor_mixin.rb", "lib/nuggets/tempfile/open.rb", "lib/nuggets/uri/content_type.rb", "lib/nuggets/uri/content_type_mixin.rb", "lib/nuggets/uri/exist.rb", "lib/nuggets/uri/exist_mixin.rb", "lib/nuggets/uri/redirect.rb", "lib/nuggets/uri/redirect_mixin.rb", "lib/nuggets/util/ansicolor2css.rb", "lib/nuggets/util/cli.rb", "lib/nuggets/util/content_type.rb", "lib/nuggets/util/dotted_decimal.rb", "lib/nuggets/util/i18n.rb", "lib/nuggets/util/lazy_attr.rb", "lib/nuggets/util/log_parser.rb", "lib/nuggets/util/log_parser/apache.rb", "lib/nuggets/util/log_parser/rails.rb", "lib/nuggets/util/midos.rb", "lib/nuggets/util/mysql.rb", "lib/nuggets/util/pluggable.rb", "lib/nuggets/util/ruby.rb", "lib/nuggets/version.rb", "spec/nuggets/array/boost_spec.rb", "spec/nuggets/array/correlation_spec.rb", "spec/nuggets/array/flush_spec.rb", "spec/nuggets/array/hashify_spec.rb", "spec/nuggets/array/histogram_spec.rb", "spec/nuggets/array/limit_spec.rb", "spec/nuggets/array/mean_spec.rb", "spec/nuggets/array/median_spec.rb", "spec/nuggets/array/mode_spec.rb", "spec/nuggets/array/regression_spec.rb", "spec/nuggets/array/runiq_spec.rb", "spec/nuggets/array/standard_deviation_spec.rb", "spec/nuggets/array/variance_spec.rb", "spec/nuggets/env/set_spec.rb", "spec/nuggets/env/user_encoding_spec.rb", "spec/nuggets/env/user_home_spec.rb", "spec/nuggets/file/ext_spec.rb", "spec/nuggets/file/replace_spec.rb", "spec/nuggets/file/sub_spec.rb", "spec/nuggets/file/which_spec.rb", "spec/nuggets/hash/deep_merge_spec.rb", "spec/nuggets/hash/nest_spec.rb", "spec/nuggets/hash/seen_spec.rb", "spec/nuggets/hash/unroll_spec.rb", "spec/nuggets/integer/length_spec.rb", "spec/nuggets/integer/map_spec.rb", "spec/nuggets/object/blank_spec.rb", "spec/nuggets/object/boolean_spec.rb", "spec/nuggets/object/msend_spec.rb", "spec/nuggets/object/silence_spec.rb", "spec/nuggets/object/singleton_class_spec.rb", "spec/nuggets/proc/bind_spec.rb", "spec/nuggets/range/quantile_spec.rb", "spec/nuggets/string/camelscore_spec.rb", "spec/nuggets/string/evaluate_spec.rb", "spec/nuggets/string/wc_spec.rb", "spec/nuggets/string/xor_spec.rb", "spec/nuggets/uri/content_type_spec.rb", "spec/nuggets/uri/exist_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/ruby-nuggets"
  s.licenses = ["AGPL-3.0"]
  s.rdoc_options = ["--title", "ruby-nuggets Application documentation (v0.9.8)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.rubygems_version = "2.2.2"
  s.summary = "Some extensions to the Ruby programming language."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<ruby-filemagic>, [">= 0"])
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<ruby-filemagic>, [">= 0"])
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<ruby-filemagic>, [">= 0"])
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
