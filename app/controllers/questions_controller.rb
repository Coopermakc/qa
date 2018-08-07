require 'pry'
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :edit, :destroy]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]
  respond_to :js, :json
  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
     @question.update(question_params)
    respond_with @question
  end


  def destroy
    if current_user.id == @question.user_id
      respond_with(@question.destroy)
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(partial: 'questions/question', locals: { q: @question })
  end

  def question_params
    params.require(:question).permit(:id,:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

end
