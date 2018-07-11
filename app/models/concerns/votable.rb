module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def count_votes
    votes.sum(:rating)
  end

  def vote_it(rating, user)
    votes.create(rating: rating, user_id: user.id)
  end

  def vote_empty?(user)
    Vote.exists?(user: user)
  end
end
