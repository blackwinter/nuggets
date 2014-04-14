$:.unshift('lib') unless $:.first == 'lib'

Float::NAN      = 0 / 0.0 unless Float.const_defined?(:NAN)
Float::INFINITY = 1 / 0.0 unless Float.const_defined?(:INFINITY)

RSpec.configure { |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

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
