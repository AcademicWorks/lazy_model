ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :choice
    t.text :old_type
    t.boolean :archived
  end

end