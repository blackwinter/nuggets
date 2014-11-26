require 'nuggets/object/rescue_if'

describe_extended Object, Nuggets::Object::RescueIfMixin do

  example {
    expect(rescue_if {}).to be_a(Module)
  }

  example {
    expect(rescue_unless {}).to be_a(Module)
  }

  example {
    expect { rescue_if }.to raise_error(ArgumentError)
  }

  example {
    expect { rescue_unless }.to raise_error(ArgumentError)
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if { true }
      42
    end).to eq(42)
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if { |e| e.message == 'foo' }
      42
    end).to eq(42)
  }

  example {
    expect { begin
      raise 'bar'
    rescue rescue_if { |e| e.message == 'foo' }
      42
    end }.to raise_error(RuntimeError, 'bar')
  }

  example {
    expect(begin
      raise 'bar'
    rescue rescue_unless { |e| e.message == 'foo' }
      42
    end).to eq(42)
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if(RuntimeError) { true }
      42
    end).to eq(42)
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if(StandardError) { true }
      42
    end).to eq(42)
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if(RuntimeError, NameError) { true }
      42
    end).to eq(42)
  }

  example {
    expect { begin
      raise 'foo'
    rescue rescue_if(NameError) { true }
      42
    end }.to raise_error(RuntimeError, 'foo')
  }

  example {
    expect(begin
      raise 'foo'
    rescue rescue_if { true } => e
      e
    end).to be_a(RuntimeError)
  }

  example {
    expect { begin
      raise Exception, 'foo'
    rescue rescue_if { true }
      42
    end }.to raise_error(Exception, 'foo')
  }

  example {
    expect(begin
      raise Exception, 'foo'
    rescue rescue_if(Exception) { true }
      42
    end).to eq(42)
  }

end
