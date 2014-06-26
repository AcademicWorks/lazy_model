module LazyModelSupport
	extend ActiveSupport::Concern
	
	included do
		attr_accessor :raw_attribute, :enumerables, :custom_finders, :column, :model, :attribute, :belongs_to
	end
	
	def initialize(model, raw_attribute, enumerables = nil, custom_finders = {})
		self.model 			= model
		self.raw_attribute 	= raw_attribute
		self.enumerables 	= Array(enumerables)
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
			self.attribute 	= raw_attribute[belongs_to]
		else
			self.attribute = raw_attribute
		end
	end

	def belongs_to_attribute
		belongs_to ? "#{belongs_to}.#{attribute}" : attribute
	end

	def define_join_finder_method
		if belongs_to
			model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
				class << self
					def #{joins_method_name}
						joins(:#{belongs_to})
					end
				end
			RUBY
		end
	end

	def klass
		belongs_to ? "#{belongs_to.to_s.camelize}" : "self"
	end

	def joins_method_name
		"with_#{belongs_to}"
	end

	def joins
		belongs_to ? "#{joins_method_name}." : nil
	end


end
