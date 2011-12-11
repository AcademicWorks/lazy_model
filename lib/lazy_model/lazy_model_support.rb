module LazyModelSupport
	extend ActiveSupport::Concern
	
	included do
		attr_accessor :raw_attribute, :enumerables, :custom_finders, :column, :model, :attribute, :belongs_to
	end
	
	def initialize(model, raw_attribute, enumerables = nil, custom_finders = {})
		self.model 			= model
		self.raw_attribute 	= raw_attribute
		self.enumerables 	= enumerables
		self.custom_finders = custom_finders
		calculate_atttribute_and_belongs_to
	end

	def to_method_name(any_string_or_symbol)
		any_string_or_symbol.to_s.underscore
	end

	private

	def calculate_atttribute_and_belongs_to
		if raw_attribute.is_a?(Hash)
			self.belongs_to = raw_attribute.keys.first
			self.attribute 	= raw_attribute[attribute]
		else
			self.attribute = raw_attribute
		end
	end

end