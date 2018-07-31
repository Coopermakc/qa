class AddNicknameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string, unique: true
  end
end
