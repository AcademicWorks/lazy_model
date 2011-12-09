module LazyModelSupport
	extend ActiveSupport::Concern
	
	included do
		attr_accessor :attribute, :enumerables, :custom_finders, :column, :model
	end
	
	def initialize(model, attribute, enumerables = nil, custom_finders = {})
		self.model 			= model
		self.attribute 		= attribute
		self.enumerables 	= enumerables
		self.custom_finders = custom_finders
	end

	def to_method_name(any_string_or_symbol)
		any_string_or_symbol.to_s.underscore
	end

end