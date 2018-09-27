require 'pry'
class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :best]
  #after_action :publish_answer, only: [:create]
  respond_to :js, :json
  authorize_resource
  def index
  end
  def new
    @answer = Answer.new
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge({ user: current_user })))
  end

  def update
     @answer = Answer.find(params[:id])
     @answer.update(answer_params)
     @question = @answer.question

  end

  def destroy
    if @answer.user_id == current_user.id
      respond_with @answer.destroy
    end
  end

  def best
    #respond_with(@answer.best)
    @answer.best #if current_user.author_of?(@question)
    @answers = @answer.question.answers
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast 'answers', ApplicationController.render(partial: 'answers/answers', locals: { question: @answer.question })
  end
  def load_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:id, :body, attachments_attributes: [:file, :id, :_delete])
  end
end
