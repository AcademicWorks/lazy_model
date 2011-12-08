Post.create(:choice => "one", :archived => true)
Post.create(:choice => "two", :archived => false)
Post.create(:choice => "three", :archived => nil)
Post.create(:choice => nil, :archived => nil)