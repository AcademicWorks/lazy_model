class Post < ActiveRecord::Base

	CHOICES = ["one", "two", "three"]
	TYPES = ["OldClass"]

	lazy_model :archived #boolean
	lazy_model :choice, Post::CHOICES, {:prime => ["one", "three"]} #string
	lazy_model :old_type, Post::TYPES

end