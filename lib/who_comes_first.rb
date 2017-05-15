class WhoComesFirst
	#Specify the model class and list of methods that you require the order of execution(optional)
	def self.who_comes_first(model,methods = [],operation = :create)
		callbacks_name_list = [:before_validation,
						 "before_validation_on_#{operation}".to_sym,
						 :after_validation,
						 "after_validation_on_#{operation}".to_sym,
						 :before_save,
						 "before_#{operation}".to_sym,
						 "after_#{operation}".to_sym,
						 :after_save,
						 "before_commit_on_#{operation}".to_sym,
						 "after_commit_on_#{operation}".to_sym
						]
		callbacks_name_list.each { |callback_name| model.send(callback_name).each { |cb| process_callback(cb,methods)}}
		nil
	end
	private
	def self.process_callback(cb,methods)
		unless cb.method.to_s =~ /before_save_collection_association|autosave_associated_records/i
			print_array = []
			methods_array = []
			options_array = []
			kind_array = []

			methods_array << cb.method.to_sym
			options_array << (cb.options.empty? ?  nil : cb.options)
			kind_array << (cb.kind.empty? ?  nil : cb.kind)

			methods_array = methods_array & methods unless methods.empty?
			
			print_array << [methods_array + options_array + kind_array]
			pp print_array.flatten.compact unless methods_array.empty?
		end	
	end
end