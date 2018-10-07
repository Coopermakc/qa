class Subscription < ApplicationRecord

  belongs_to :user
  validates :user_id, presence: true
  validates :question_id, presence: true
  #validates :user_id, uniqueness: question_id
end
