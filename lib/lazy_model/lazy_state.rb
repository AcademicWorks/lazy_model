module LazyModel
	
	class LazyState

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
					def #{to_method_name(enumerable)}?
						#{belongs_to_attribute} == "#{enumerable}"
					end
				LZY
			end
		end

		def define_instance_custom
			custom_finders.each do |custom_finder, values|
				model.class_eval <<-LZY
					def #{to_method_name(custom_finder)}?
						#{values}.include?(#{belongs_to_attribute})
					end
				LZY
			end
		end

		def belongs_to_attribute
			belongs_to ? "#{belongs_to}.#{attribute}" : attribute
		end


		##### CLASS METHODS ##########

		def define_class_methods
			define_join_finder_method
			define_core_class_finder_methods
			define_enumerables_class_finder_methods
			define_custom_class_finder_methods
		end

		def define_join_finder_method
			if belongs_to
				model.class_eval <<-LZY
					class << self
						def #{joins_method_name}
							"joins(:#{belongs_to})"
						end
					end
				LZY
			end
		end

		def define_core_class_finder_methods
			model.class_eval <<-LZY
				class << self

					def #{to_method_name(attribute)}(value = nil)
						table = #{klass}.arel_table[:#{attribute}]
						
						filter = case value.class.to_s
							when 'Array' 			then	table.in(value)
							when 'NilClass' 		then	table.not_eq(value)
							when 'String', 'Symbol' then	table.eq(value)
							else raise "\'" + value + "\' with class \'"+value.class.to_s+ "\' is not valid comparitor"
						end

						#{joins}where(filter)
					end

					def not_#{to_method_name(attribute)}(value = nil)
						table = #{klass}.arel_table[:#{attribute}]

						filter = case value.class.to_s
							when 'Array' 			then	table.not_in(value)
							when 'NilClass'			then	table.eq(value)
							when 'String', 'Symbol' then	table.not_eq(value)
							else raise "\'" + value + "\' with class \'"+value.class.to_s+ "\' is not valid comparitor"
						end

						#{joins}where(filter)
					end

				end
			LZY
		end

		def define_enumerables_class_finder_methods
			enumerables.each do |enumerable|
				model.class_eval <<-LZY
					class << self

						def #{to_method_name(enumerable)}
							#{to_method_name(attribute)}("#{enumerable}")
						end

						def not_#{to_method_name(enumerable)}
							not_#{to_method_name(attribute)}("#{enumerable}")
						end

					end
				LZY
			end
		end

		def define_custom_class_finder_methods
			custom_finders.each do |custom_finder, values|
				model.class_eval <<-LZY
					class << self
						def #{to_method_name(custom_finder)}
							#{to_method_name(attribute)}(#{values})
						end

						def not_#{to_method_name(custom_finder)}
							not_#{to_method_name(attribute)}(#{values})
						end
					end
				LZY
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

end