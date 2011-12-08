class Post < ActiveRecord::Base

	CHOICES = ["one", "two", "three"]

	lazy_model :archived #boolean
	lazy_model :choice, Post::CHOICES, {:prime => ["one", "three"]} #string

end