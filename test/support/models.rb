class Post < ActiveRecord::Base

	CHOICES = ["one", "two", "three"]
	TYPES = ["OldClass"]

	lazy_boolean :archived #boolean
	lazy_state :choice, Post::CHOICES, {:prime => ["one", "three"]} #string
	lazy_state :old_type, Post::TYPES

end