class Question < ApplicationRecord

  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, :title, presence: true

  after_create :author_subscribe

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def best_answer
    answers.where(best: true).first
  end
  private

  def author_subscribe
    subscriptions.create!(user: user)
  end
end
