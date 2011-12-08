module LazyModel
	
	class LazyString

		include LazyModelSupport

		def define_methods
			define_instance_methods
			define_class_methods
		end

		private

		##### INSTANCE METHODS ##########

		def define_instance_methods
			define_instance_enumerables
			define_instance_custom
		end

		def define_instance_enumerables
			enumerables.each do |enumerable|
				model.class_eval <<-LZY
					def #{enumerable}?
						#{attribute} == "#{enumerable}"
					end
				LZY
			end
		end

		def define_instance_custom
			custom_finders.each do |custom_finder, values|
				model.class_eval <<-LZY
					def #{custom_finder}?
						#{values}.include?(#{attribute})
					end
				LZY
			end
		end


		##### CLASS METHODS ##########

		def define_class_methods
			define_core_class_finder_methods
			define_enumerables_class_finder_methods
			define_custom_class_finder_methods
		end

		def define_core_class_finder_methods
			model.class_eval <<-LZY
				class << self

					def #{attribute}(value = nil)
						table = self.arel_table[:#{attribute}]
						
						filter = case value.class.to_s
							when 'Array' 			then	table.in(value)
							when 'NilClass' 		then	table.not_eq(value)
							when 'String', 'Symbol' then	table.eq(value)
							else raise "\'" + value + "\' with class \'"+value.class.to_s+ "\' is not valid comparitor"
						end

						where(filter)
					end

					def not_#{attribute}(value = nil)
						table = self.arel_table[:#{attribute}]

						filter = case value.class.to_s
							when 'Array' 			then	table.not_in(value)
							when 'NilClass'			then	table.eq(value)
							when 'String', 'Symbol' then	table.not_eq(value)
							else raise "\'" + value + "\' with class \'"+value.class.to_s+ "\' is not valid comparitor"
						end

						where(filter)
					end

				end
			LZY
		end

		def define_enumerables_class_finder_methods
			enumerables.each do |enumerable|
				model.class_eval <<-LZY
					class << self

						def #{enumerable}
							#{attribute}("#{enumerable}")
						end

						def not_#{enumerable}
							not_#{attribute}("#{enumerable}")
						end

					end
				LZY
			end
		end

		def define_custom_class_finder_methods
			custom_finders.each do |custom_finder, values|
				model.class_eval <<-LZY
					class << self
						def #{custom_finder}
							#{attribute}(#{values})
						end

						def not_#{custom_finder}
							not_#{attribute}(#{values})
						end
					end
				LZY
			end

		end

	end

end