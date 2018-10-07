class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
    end
  end
end
