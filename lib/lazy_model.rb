require 'active_record'
require 'active_support'
require 'active_support/core_ext/module/delegation'

require File.dirname(__FILE__) + '/lazy_model/lazy_model.rb'
require File.dirname(__FILE__) + '/lazy_model/lazy_model_support.rb'

require File.dirname(__FILE__) + '/lazy_model/lazy_boolean.rb'
require File.dirname(__FILE__) + '/lazy_model/lazy_string.rb'
require File.dirname(__FILE__) + '/lazy_model/lazy_text.rb'


module LazyModel

	def lazy_model(attribute, enumerables = nil, custom_finders = {})
		LazyModel.new(self, attribute, enumerables, custom_finders).define_methods
	end

end

ActiveRecord::Base.extend LazyModel