module LazyModel
	
	class LazyState

		include LazyModelSupport

		def define_methods
			setup_custom_lazy_finders
			define_instance_methods
			define_class_methods
		end

		private

		##### INSTANCE METHODS ##########

		def setup_custom_lazy_finders
			return if custom_finders.empty? or  model.respond_to?(:custom_lazy_finders)

			class << model ; attr_accessor :custom_lazy_finders ; end
			model.custom_lazy_finders = {}
		end

		def define_instance_methods
			define_instance_belongs_to
			define_instance_enumerables
			define_instance_custom
		end

		def define_instance_belongs_to
			if belongs_to
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					def #{attribute}
						#{belongs_to_attribute}
					end
				RUBY
			end
		end

		def define_instance_enumerables
			enumerables.each do |enumerable|
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					def #{to_method_name(enumerable)}?
						#{belongs_to_attribute} == "#{enumerable}"
					end
				RUBY
			end
		end

		def define_instance_custom
			custom_finders.each do |custom_finder, values|
				finder_name = to_method_name(custom_finder)
				model.custom_lazy_finders[finder_name] = values
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					def #{finder_name}?
						self.class.custom_lazy_finders['#{finder_name}'].include?(#{belongs_to_attribute})
					end
				RUBY
			end
		end


		##### CLASS METHODS ##########

		def define_class_methods
			define_join_finder_method
			define_core_class_finder_methods
			define_enumerables_class_finder_methods
			define_custom_class_finder_methods
		end

		def define_core_class_finder_methods
			[['', 'not_'], ['not_', '']].each do |pos, neg|
				model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
					class << self

						def #{pos}#{to_method_name(attribute)}(value = nil)
							table = #{klass}.arel_table[:#{attribute}]
						
							filter = case value.class.to_s
								when 'Array' 			then	table.#{pos}in(value)
								when 'NilClass' 		then	table.#{neg}eq(value)
								when 'String', 'Symbol' then	table.#{pos}eq(value)
								else raise "\'" + value + "\' with class \'"+value.class.to_s+ "\' is not valid comparitor"
							end

							#{joins}where(filter)
						end
					end
				RUBY
			end
		end

		def define_enumerables_class_finder_methods
			enumerables.each do |enumerable|
				['', 'not_'].each do |mode|
					model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
						class << self

							def #{mode}#{to_method_name(enumerable)}
								#{mode}#{to_method_name(attribute)}("#{enumerable}")
							end

						end
					RUBY
				end
			end
		end

		def define_custom_class_finder_methods
			custom_finders.each do |custom_finder, values|
				finder_name = to_method_name(custom_finder)
				['', 'not_'].each do |mode|
					model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
						class << self
							def #{mode}#{to_method_name(custom_finder)}
								#{mode}#{to_method_name(attribute)}(custom_lazy_finders['#{finder_name}'])
							end

						end
					RUBY
				end
			end
		end

	end

end
