class AddSearchFieldInModels < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :searching, :boolean, default: false
    add_column :questions, :searching, :boolean, default: false
  end
end
