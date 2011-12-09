require 'active_record'
require 'active_support'
require 'active_support/core_ext/module/delegation'

require File.dirname(__FILE__) + '/lazy_model/lazy_model_support.rb'

require File.dirname(__FILE__) + '/lazy_model/lazy_boolean.rb'
require File.dirname(__FILE__) + '/lazy_model/lazy_state.rb'


module LazyModel

	def lazy_boolean(attribute)
		LazyBoolean.new(self, attribute).define_methods
	end

	def lazy_state(attribute, enumerables = nil, custom_finders = {})
		LazyState.new(self, attribute, enumerables, custom_finders).define_methods
	end


end

ActiveRecord::Base.extend LazyModel