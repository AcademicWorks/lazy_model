require 'helper'

class TestLazyModel < Test::Unit::TestCase

	context "LazyBoolean" do
	
		should "provide truthy boolean finder" do
			assert Post.respond_to?(:archived)
		end

		should "provide falsey boolean finder" do
			assert Post.respond_to?(:not_archived)
		end

		should "provide nil boolean finder" do
			assert Post.respond_to?(:nil_archived)
		end

		should "return only truthy values for truthy finder" do
			assert_equal Post.archived.map{|p| p.choice}, ['one']
		end

		should "return only falsey values for falsey finder" do
			assert_equal Post.not_archived.map{|p| p.choice}, ['two']
		end

		should "return only nil values for nil finder" do
			assert_equal Post.nil_archived.map{|p| p.choice}.sort_by{|c| c ? 1 : 0}, [nil, 'three']
		end

	end

	context "LazyString" do

		should "make all enumerables underscore case" do
			assert Post.respond_to?(:old_class)
		end

		context "Instance Methods" do

			should "provide attribute options as question methods" do
				Post::CHOICES.each do |choice|
					assert Post.new.respond_to?("#{choice}?")
				end
			end

			should "be true if attribute is set to corresponding value" do
				assert Post.new(:choice => "one").one?
			end

			should "be false if attribute is not set to corresponding value" do
				refute Post.new(:choice => "two").one?
			end

			should "provide custom attribute options as question methods" do
				assert Post.new.respond_to?("prime?")
			end

			should "be true if custom attribute is set to corresponding value" do
				assert Post.new(:choice => "one").prime?
			end

			should "be false if custom attribute is not set to corresponding value" do
				refute Post.new(:choice => "two").prime?
			end

		end

		context "Class Methods" do

			should "have core presence finder that accepts nil" do
				assert Post.respond_to?(:choice)
			end

			should "have core presence finder that accepts value" do
				assert Post.respond_to?(:choice, "one")
			end

			should "have core absence finder that accepts nil" do
				assert Post.respond_to?(:not_choice)
			end

			should "have core absence finder that accepts value" do
				assert Post.respond_to?(:not_choice, "one")
			end

			should "return correct records for finder w/ nil for core presence finder" do
				assert Post.choice.all.select {|p| !p.choice}.empty?
			end

			should "return correct records for finder w/ nil for core absence finder" do
				assert Post.not_choice.all.select {|p| p.choice}.empty?
			end

			should "return only records of enumerable type for enumerable finder" do
				assert Post.one.all.select {|p| p.choice != "one" }.empty?
			end

			should "not return records of enumerable type for enumerable NOT finder" do
				assert Post.not_one.all.select {|p| p.choice == "one" }.empty?
			end

			should "return only records with custom atributes for finder" do
				assert Post.prime.all.select {|p| !["one", "three"].include?(p.choice) }.empty?
			end

			should "return not records with custom atributes for NOT finder" do
				assert Post.not_prime.all.select {|p| ["one", "three"].include?(p.choice) }.empty?
			end


		end


	end

end
