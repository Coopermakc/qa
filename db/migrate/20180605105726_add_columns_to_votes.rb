class AddColumnsToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :rating, :integer
    add_column :votes, :user_id, :integer
    add_column :votes, :votable_id, :integer
    add_column :votes, :votable_type, :string

    add_index :votes, :user_id
    add_index :votes, [:votable_id, :votable_type]
  end
end
