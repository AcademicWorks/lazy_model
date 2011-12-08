module LazyModel
	
	class LazyModel

		attr_accessor :model, :attribute, :enumerables, :custom_finders, :column
	
		def initialize(model, attribute, enumerables = nil, custom_finders = {})
			self.model 			= model
			self.attribute 		= attribute
			self.enumerables 	= format_enumerables(enumerables)
			self.custom_finders = custom_finders
		end

		def define_methods
			#make sure the column exists
			unless self.column = model.columns_hash[attribute.to_s]
				raise "\'#{attribute}\' is not an attribute for \'#{model.to_s}\' model"
			end

			#pass to lazy class id supported
			begin
				klass = "LazyModel::Lazy#{column.type.to_s.camelize}".constantize
				klass.new(self).define_methods
			rescue NameError
				raise " attribute type \'#{column.type}\'' on \'#{attribute}\' is not supported "				
			end
		end

		private

		def format_enumerables(enumerables)
			Array(enumerables).map{|enumerable| enumerable.underscore}
		end

	end

end