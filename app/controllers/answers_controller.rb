require 'pry'
class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :best]
  after_action :publish_answer, only: [:create]
  def index
  end
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    # if @answer.save
    #   flash[:notice] = 'Your answer successfully create.'
    #   redirect_to @question
    # else
    #   render :new
    # end
    respond_to do |format|
      if @answer.save
        format.js
      else
        format.js { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
      gon.watch.answers = @answer.question.answers
    end

  end

  def update
     @answer = Answer.find(params[:id])
     @answer.update(answer_params)
     @question = @answer.question

  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
    else
      flash[:notice] = 'You don`t have right for delete'
      redirect_to questions_path
    end
  end

  def best
    if current_user.author_of?(@answer.question)
      @answer.best
      flash[:notice] = 'Choose the best answer'
      @question = @answer.question
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?
    #ActionCabel.server.broadcast 'answers', ApplicationController.render(partial: 'questions/answers', assigns: { question: @answer.question })
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
