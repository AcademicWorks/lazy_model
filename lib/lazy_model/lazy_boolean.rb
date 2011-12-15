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
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					def #{attribute}?
						#{belongs_to_attribute}?
					end

					def #{attribute}
						#{belongs_to_attribute}
					end

				RUBY
			end
		end

		def define_class_methods
			model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
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
			RUBY
		end


	end

end
