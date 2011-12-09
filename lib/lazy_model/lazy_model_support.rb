module LazyModelSupport
	extend ActiveSupport::Concern
	
	included do
		attr_accessor :attribute, :enumerables, :custom_finders, :column, :model
	end
	
	def initialize(model, attribute, enumerables = nil, custom_finders = {})
		self.model 			= model
		self.attribute 		= attribute
		self.enumerables 	= format_enumerables(enumerables)
		self.custom_finders = custom_finders
	end

	private

	def format_enumerables(enumerables)
		Array(enumerables).map{|enumerable| enumerable.underscore}
	end


end