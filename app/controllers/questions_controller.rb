class QuestionsController < ApplicationController
  before_action :admin_user, only: [:create, :edit, :update, :destroy, :up, :down]

  def edit
    @question = Question.find( params[:id] )
  end

  def update
    @question = Question.find( params[:id] )
    @question.update(question_params)
    if @question.save
      flash[:success] = t('controllers.question_updated')
      redirect_to faq_path
    else
      render 'edit'
    end
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    @question.score = Question.all.count
    if @question.save
      flash[:success] = t('controllers.question_added')
      redirect_to faq_path
    else
      redirect_to faq_path
    end
  end

  def destroy
    Question.find( params[:id] ).destroy
    redirect_to faq_path
  end

  def up
    up_id = Question.find_by(score: (Question.find(params[:id]).score - 1) ).id
    Question.decrement_counter(:score, params[:id] )
    Question.increment_counter(:score, up_id )
    redirect_to faq_path
  end

  def down
    down_id = Question.find_by(score: (Question.find(params[:id]).score + 1) ).id
    Question.increment_counter(:score, params[:id] )
    Question.decrement_counter(:score, down_id )
    redirect_to faq_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
