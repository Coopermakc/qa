class AnswerAddBest < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
