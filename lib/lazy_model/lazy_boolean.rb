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
			{'true' => '', 'false' => 'not_', 'nil' => 'nil_'}.each do |predicate, prefix|
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					class << self
	
						def #{prefix}#{attribute}
							#{joins}where(#{klass}.arel_table[:#{attribute}].eq(#{predicate}))
						end

					end
				RUBY
			end
		end


	end

end
