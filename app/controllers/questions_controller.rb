class QuestionsController < ApplicationController
  before_action :admin_user, only: [:create, :edit, :update, :destroy]

  def edit
    @question = Question.find( params[:id] )
  end

  def update
    @question = Question.find( params[:id] )
    @question.update(question_params)
    if @question.save
      flash[:success] = "Changements sauvegardés !"
      redirect_to faq_path
    else
      render 'edit'
    end
  end
  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      flash[:success] = "Q&A ajoutée !"
      redirect_to faq_path
    else
      redirect_to faq_path
    end
  end

  def destroy
    Question.find( params[:id] ).destroy
    redirect_to faq_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
