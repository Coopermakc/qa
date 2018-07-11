class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :comment_body
      t.references :user
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
