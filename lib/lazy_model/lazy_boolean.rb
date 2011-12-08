module LazyModel
	
	class LazyBoolean

		include LazyModelSupport

		def define_methods
			define_class_methods
		end

		private

		def define_class_methods
			model.class_eval <<-LZY
				class << self
	
					def #{attribute}
						where(self.arel_table[:#{attribute}].eq(true))
					end

					def not_#{attribute}
						where(self.arel_table[:#{attribute}].eq(false))
					end

					def nil_#{attribute}
						where(self.arel_table[:#{attribute}].eq(nil))
					end

				end
			LZY
		end


	end

end