module LazyModel
	
	class LazyBoolean

		include LazyModelSupport

		def define_methods
			define_instance_methods
			define_class_methods
		end

		private

		def define_instance_methods
			if belongs_to
				model.class_eval <<-LZY
					def #{attribute}?
						#{belongs_to_attribute}?
					end

					def #{attribute}
						#{belongs_to_attribute}
					end

				LZY
			end
		end

		def define_class_methods
			model.class_eval <<-LZY
				class << self
	
					def #{attribute}
						#{joins}where(#{klass}.arel_table[:#{attribute}].eq(true))
					end

					def not_#{attribute}
						#{joins}where(#{klass}.arel_table[:#{attribute}].eq(false))
					end

					def nil_#{attribute}
						#{joins}where(#{klass}.arel_table[:#{attribute}].eq(nil))
					end

				end
			LZY
		end


	end

end