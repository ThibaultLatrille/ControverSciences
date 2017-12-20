class AssistantController < ApplicationController
  include AssisstantHelper
  include LatexHelper

  before_action :admin_user, only: [:view, :index, :users, :timelines, :profils, :pdflatex, :partial_tex]

  def view
  end

  def index
    pending_users = Hash[PendingUser.where.not(refused: true).pluck( :user_id, :why)]
    @users = User.where( id: pending_users.keys  )
    @users.each do |user|
      user.why = pending_users[user.id]
    end
  end

  def partial_tex
    LatexToPdf.config[:parse_runs] = 1
    @text  = params[:partial_tex][:text]
  end

  def pdflatex
    LatexToPdf.config[:parse_runs] = 1

    @frames = []
    @summaries = []
    @references = []
    @comments = []
    parse_frames = false
    parse_summaries = false
    parse_references = false
    parse_comments = true

    if parse_frames
      Frame.all.each do |frame|
        render_to_pdf(frame, frame.name, @frames)
        render_to_pdf(frame, frame.content, @frames)
      end
    end

    if parse_summaries
      Summary.all.each do |summary|
        render_to_pdf(summary, summary.content, @summaries)
      end
    end

    if parse_references
      Reference.all.each do |ref|
        render_to_pdf(ref, ref.author, @references)
        unless ref.abstract.blank?
          render_to_pdf(ref, ref.abstract, @references)
        end
      end
    end

    if parse_comments
      Comment.all.each do |comment|
        render_to_pdf(comment, comment.all_content, @comments)
      end
    end

    respond_to do |format|
      format.html { render template: 'assistant/pdflatex.html.erb'}
    end
  end

  def timelines
    update_score_timelines
    flash[:success] = t('controllers.updated_score_timelines')
    redirect_to assistant_path
  end

  def profils
    update_all_profils
    flash[:success] = t('controllers.updated_profils')
    redirect_to assistant_path
  end
end
