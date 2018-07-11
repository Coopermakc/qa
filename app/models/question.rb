class Question < ApplicationRecord

  include Votable
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, :title, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def best_answer
    answers.where(best: true).first
  end
end
