class VotesController < ApplicationController


  before_action :authenticate_user!
  before_action :load_votable
  before_action :author_votable, only: [:up_rating, :down_rating]

  respond_to :json

  def up_rating
    vote(1)
  end
  def down_rating
    vote(-1)
  end

  def unvote
    @vote = Vote.find_by(user_id: current_user.id, votable: @votable)
    if @vote && current_user.author_of?(@vote)
      @vote.destroy
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    else
      head :forbidden
    end
  end

  private

  def vote(value)
    @vote = @votable.vote_it(value, current_user)
    if @vote
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    end
  end

  def load_votable
    parent = params.to_unsafe_h.detect { |k, v| k.to_s =~ /_id/ }
    klass_name = parent.first.to_s.gsub('_id', '')
    klass = klass_name.classify.constantize
    @votable = klass.find(parent.last)
  end

  def author_votable
    head(:forbidden) if current_user.author_of?(@votable) || @votable.vote_empty?(current_user)
  end

end
