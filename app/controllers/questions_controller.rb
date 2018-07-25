require 'pry'
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :edit, :destroy]

  after_action :publish_question, only: [:create]
  respond_to :js, :json

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end


  def destroy
    if current_user.id == @question.user_id

      respond_with(@question.destroy)
    #   redirect_to questions_path
    # else
    #   flash[:notice] = 'Don`t have right for delete'
    #   redirect_to questions_path
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(partial: 'questions/question', locals: { q: @question })
  end

  def question_params
    params.require(:question).permit(:id,:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

end
