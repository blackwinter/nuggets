$:.unshift('lib') unless $:[0] == 'lib'

#class << Spec::Matchers
#
#  def generated_description
#    return nil if last_should.nil?
#
#    operator = last_should.to_s.tr('_', ' ')
#    target = last_matcher.instance_variable_get(:@actual)
#
#    "#{target.inspect} #{operator} #{last_description}"
#  end
#
#end
