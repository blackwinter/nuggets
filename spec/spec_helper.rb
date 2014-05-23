$:.unshift('lib') unless $:.first == 'lib'

Float::NAN      = 0 / 0.0 unless Float.const_defined?(:NAN)
Float::INFINITY = 1 / 0.0 unless Float.const_defined?(:INFINITY)

RSpec.configure { |config|
  %w[expect mock].each { |what|
    config.send("#{what}_with", :rspec) { |c| c.syntax = [:should, :expect] }
  }

  config.include(Module.new {
    def equal_float(value, precision = 1.0e-14)
      be_within(precision).of(value)
    end

    def tempfile(txt = @txt)
      t = Tempfile.open("nuggets_spec_#{object_id}_temp") { |f| f.puts txt }
      block_given? ? yield(t.path) : t.path
    ensure
      t.close(true) if t
    end
  })
}

extend(Module.new {
  def describe_extended(mod, ext, singleton = false, &block)
    describe(mod, "when extended by #{ext}") {
      example {
        klass = singleton ? class << mod; self; end : mod
        klass.ancestors.should include(ext)
      }

      class_eval(&block)
    }
  end
})
