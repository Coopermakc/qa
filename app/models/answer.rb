class Answer < ApplicationRecord

  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  def best
    ActiveRecord::Base.transaction do
      best_answer = question.best_answer
      if self != best_answer
        best_answer.update!(best: false) if best_answer
        self.update!(best: true)
      end
    end
  end

end
