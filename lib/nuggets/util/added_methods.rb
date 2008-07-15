# watch for added methods and record them
# cf. <http://unroller.rubyforge.org/classes/Unroller.html#M000034>

# TODO:
# - multi-line statements in irb (extract_source)
# - polishing!

require 'ruby2ruby'

module AddedMethods

  extend self

  HISTFILENAME = '(Readline::HISTORY)'.freeze

  class AddedMethod < Hash

    def initialize(*args)
      update(*args) unless args.empty?
    end

    def extract_source(num_lines = nil)
      return unless Object.const_defined?(:SCRIPT_LINES__)
      return unless script_lines = SCRIPT_LINES__[file]

      start, from, to = line - 1, line, script_lines.size - 1

      # suppose we're already in a block
      in_block = 1

      num_lines ||= case definition = script_lines[start]
        # def ... end, or do ... end style block
        when /\b(?:def|do)\b/
          definition =~ /\bend\b/ ? 1 : begin
            from.upto(to) { |i|
              case line = script_lines[i]
                when /[^;\s]\s+(?:if|unless)\b/
                  # probably postfix conditional, ignore
                when /\b(?:if|unless|while|until|def|do)\b/
                  in_block += 1
                when /\bend\b/
                  in_block -= 1
              end

              break i - start + 1 if in_block.zero?
            }
          end
        # { ... } style block
        when /\bdefine_method\b/
          from.upto(to) { |i|
            line = script_lines[i]

            in_block += line.count('{')
            in_block -= line.count('}')

            break i - start + 1 if in_block.zero?
          }
        else
          1
      end

      lines = script_lines[start, num_lines]

      # try to make sure we correctly extracted the method definition
      if lines.first =~ /\b#{name}\b/
        lines
      else
        # use Ruby2Ruby as a last resort. but note that it only
        # ever finds the *latest*, i.e. currently active, method
        # definition, not necessarily the one we're looking for.
        "#### [R2R] ####\n#{Ruby2Ruby.translate(klass, name)}"
      end
    end

    def to_s(num_lines = nil)
      "# File #{file}, line #{line}\n#{extract_source(num_lines).map { |l| "  #{l}" }}"
    end

    def klass
      self[:class]
    end

    def method_missing(method, *args)
      has_key?(method) ? self[method] : super
    end

  end

  def init(regexp = nil, klasses = [], &block)
    init_script_lines
    patch_readline_history

    define_callback(:__init, regexp, klasses, &block) if regexp
    install_callbacks
  end

  def callbacks
    init_callbacks
    CALLBACKS
  end

  def callback(*args, &inner_block)
    callback_args = [identify_added_method(*args << caller), caller, inner_block]
    callbacks.each { |name, callback| callback[*callback_args] }
  end

  def define_callback(name, regexp = //, klasses = [], &outer_block)
    raise TypeError, "wrong argument type #{name.class} (expected Symbol)" unless name.is_a?(Symbol)
    raise "callback with name #{name} already exists" if callbacks.any? { |n, _| n == name }

    raise TypeError, "wrong argument type #{regexp.class} (expected Regexp)" unless regexp.is_a?(Regexp)
    raise TypeError, "wrong argument type #{klasses.class} (expected container object)" unless klasses.respond_to?(:empty?) && klasses.respond_to?(:include?)

    callbacks << [name, lambda { |am, callstack, inner_block|
      method, klass = am.values_at(:name, :class)

      return if %w[method_added singleton_method_added].include?(method)

      return unless klasses.empty? || klasses.include?(klass.to_s)
      return unless method =~ regexp

      if outer_block || inner_block
        outer_block[am] if outer_block
        inner_block[am] if inner_block
      else
        msg = "[#{am.base}] Adding #{'singleton ' if am.singleton}method #{klass}##{method}"

        msg << if irb?(callstack)
          " in (irb:#{IRB.conf[:MAIN_CONTEXT].instance_variable_get(:@line_no)})"
        else
          " at #{where(callstack)}"
        end

        puts msg
      end
    }]
  end

  def remove_callback(name)
    callbacks.delete_if { |n, _| n == name }
  end

  def replace_callback(name, regexp = nil, klasses = [], &outer_block)
    remove_callback(name)
    define_callback(name, regexp, klasses, &outer_block)
  end

  def install_callbacks(bases = [Object, Class, Module, Kernel])
    bases.each { |base|
      [base, singleton_class(base)].each { |b|
        b.send(:define_method, :method_added)           { |id| AddedMethods.callback(b, self, id, false) }
        b.send(:define_method, :singleton_method_added) { |id| AddedMethods.callback(b, self, id, true)  }
      }
    }
  end

  def all_methods
    init_all_methods
    ALL_METHODS
  end

  def find(conditions = {})
    conditions = conditions.dup

    class_condition = conditions.delete(:class)
    file_condition  = conditions.delete(:file)

    results = []

    all_methods.each { |klass, files|
      if class_condition
        next unless class_condition.is_a?(Array) ? class_condition.include?(klass) : klass == class_condition
      end

      files.each { |file, entries|
        if file_condition
          next unless file_condition.is_a?(Regexp) ? file =~ file_condition : file == file_condition
        end

        entries.each { |entry|
          results << entry.merge(
            :class => klass,
            :file  => file
          ) if conditions.all? { |key, value|
            case value
              when Array:  value.include?(entry[key])
              when Regexp: entry[key].to_s =~ value
              else         entry[key] == value
            end
          }
        }
      }
    }

    results
  end

  def find_by_class(*classes)
    conditions = classes.last.is_a?(Hash) ? classes.pop : {}
    find(conditions.merge(:class => classes))
  end

  def find_by_name(*names)
    conditions = names.last.is_a?(Hash) ? names.pop : {}
    names.inject([]) { |memo, name|
      memo += find(conditions.merge(:name => name.to_s))
    }
  end

  def find_one_by_name_or_class(name_or_class, conditions = {})
    (name_or_class.is_a?(Class) ?
      find_by_class(name_or_class) :
      find_by_name(name_or_class)
    ).last
  end

  alias_method :[], :find_one_by_name_or_class

  private

  def singleton_class(klass = self)
    class << klass; self; end
  end

  def init_script_lines
    unless Object.const_defined?(:SCRIPT_LINES__)
      Object.const_set(:SCRIPT_LINES__, {})
    end
  end

  def init_callbacks
    unless const_defined?(:CALLBACKS)
      const_set(:CALLBACKS, [])
      define_callback(:__default, //, [], &added_method_callback)
    end
  end

  def init_all_methods
    unless const_defined?(:ALL_METHODS)
      const_set(:ALL_METHODS, Hash.new { |h, k|
        h[k] = Hash.new { |i, j|
          i[j] = []
        }
      })
    end
  end

  def patch_readline_history
    return unless have_readline_history?
    return if Readline::HISTORY.respond_to?(:_added_methods_original_push)

    class << Readline::HISTORY
      alias_method :_added_methods_original_push, :push

      def push(l)
        (SCRIPT_LINES__[HISTFILENAME] ||= Readline::HISTORY.to_a) << l
        _added_methods_original_push(l)
      end

      alias_method :<<, :push
    end
  end

  def have_readline_history?
    Object.const_defined?(:Readline) && Readline.const_defined?(:HISTORY)
  end

  def defined_in_irb?(callstack)
    callstack = callstack.dup

    callstack.shift  # ignore immediate caller
    callstack.reject! { |c| c =~ /\(irb\):|:in `irb_binding'/ }
    callstack.pop if callstack.last =~ %r{/irb/workspace\.rb:}

    callstack.empty?
  end

  def irb?(callstack)
    have_readline_history? && defined_in_irb?(callstack)
  end

  def where(callstack, default = '(none):0')
    callstack.find { |i| i !~ /:in `.*'/ } || callstack[1] || default
  end

  def added_method_callback
    lambda { |am| add_method(am) }
  end

  def add_method(am)
    am = AddedMethod.new(am) unless am.is_a?(AddedMethod)
    all_methods[am.klass][am.file] << am
  end

  def identify_added_method(base, klass, id, singleton, callstack)
    am = {
      :base      => base,
      :class     => klass,
      :name      => id.id2name,
      :singleton => singleton
    }

    if irb?(callstack)
      am.update(
        :file   => HISTFILENAME,
        :line   => Readline::HISTORY.size,
        :source => begin Readline::HISTORY[-1] rescue IndexError end
      )
    else
      file, line, _ = where(callstack).split(':')
      line = line.to_i

      am.update(
        :file   => file,
        :line   => line,
        :source => (SCRIPT_LINES__[file] || [])[line - 1]
      )
    end

    AddedMethod.new(am)
  end

end
