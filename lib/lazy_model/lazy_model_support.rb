module LazyModelSupport
	extend ActiveSupport::Concern
	
	included do
		attr_accessor :lazy_model
		delegate :model, :attribute, :enumerables, :custom_finders, :column, :to => :lazy_model	
	end

	def initialize(lazy_model)
		self.lazy_model = lazy_model
	end

end