class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    comment = Comment.find_by( user_id: current_user.id, reference_id: params[:reference_id] )
    if comment
      redirect_to edit_comment_path( id: comment.id )
    else
      @comment = Comment.new
      reference = Reference.select(:id, :timeline_id).find( params[:reference_id] )
      @comment.reference_id = reference.id
      @comment.timeline_id = reference.timeline_id
      if params[:improve]
        best_comment = BestComment.find_by(reference_id: params[:reference_id])
        for fi in 0..5 do
          if best_comment["f_#{fi}_comment_id".to_sym]
            @comment["f_#{fi}_content".to_sym] = Comment.select( "f_#{fi}_content".to_sym ).find( best_comment["f_#{fi}_comment_id".to_sym] )["f_#{fi}_content".to_sym ]
          end
        end
        if best_comment.f_6_comment_id
          @comment.title = Comment.select( :title ).find( best_comment.f_6_comment_id ).title
        end
      end
      @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
      @tim_list = Timeline.where( id: Edge.where(timeline_id:
                @comment.timeline_id ).pluck(:target) ).pluck( :name, :id )
      @myreference = Reference.find( @comment.reference_id )
    end
  end

  def create
    @comment = Comment.new( comment_params )
    if comment_params[:has_picture] == 'true' && comment_params[:delete_picture] == 'false'
      @comment.figure_id = Figure.order( :created_at ).where( user_id: current_user.id,
                                                              reference_id: @comment.reference_id ).last.id
      @comment.caption = comment_params[:caption]
    end
    @comment.user_id = current_user.id
    if @comment.is_same_as_best
      flash[:info] = "Une ou plusieurs sous-parties de vos sont identiques à l'originale, elle n'ont pas été sauvegardé"
    end
    if @comment.save_with_markdown( timeline_url( comment_params[:timeline_id] ) )
      flash[:success] = "Analyse enregistrée."
      redirect_to reference_path( @comment.reference_id, filter: :mine )
    else
      @myreference = Reference.find( @comment.reference_id )
      @list = Reference.where( timeline_id: comment_params[:timeline_id] ).pluck( :title, :id )
      @tim_list = Timeline.where( id: Edge.where(timeline_id:
                                                     comment_params[:timeline_id] ).pluck(:target) ).pluck( :name, :id )
      render 'new'
    end
  end

  def edit
    @comment = Comment.find( params[:id] )
    @myreference = Reference.find( @comment.reference_id )
    @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
    @tim_list = Timeline.where( id: Edge.where(timeline_id:
                                                   @comment.timeline_id ).pluck(:target) ).pluck( :name, :id )
  end

  def update
    @comment = Comment.find( params[:id] )
    if @comment.user_id == current_user.id || current_user.admin
      @comment.public = comment_params[:public]
      for fi in 0..5 do
        @comment["f_#{fi}_content".to_sym] = comment_params["f_#{fi}_content".to_sym]
      end
      @comment.title = comment_params[:title]
      @comment.caption = comment_params[:caption]
      if comment_params[:delete_picture] == 'true'
        @comment.figure_id = nil
      elsif comment_params[:has_picture] == 'true'
        @comment.figure_id = Figure.order( :created_at ).where( user_id: current_user.id,
          reference_id: @comment.reference_id ).last.id
      end
      if @comment.update_with_markdown( timeline_url( @comment.timeline_id ) )
        flash[:success] = "Analyse modifiée."
        redirect_to reference_path( @comment.reference_id, filter: :mine )
      else
        @myreference = Reference.find( @comment.reference_id )
        @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
        @tim_list = Timeline.where( id: Edge.where(timeline_id:
                                                       @comment.timeline_id ).pluck(:target) ).pluck( :name, :id )
        render 'edit'
      end
    else
      redirect_to @comment
    end
  end

  def show
    @comment = Comment.find(params[:id])
    unless @comment.public
      if current_user && current_user.id == @comment.user_id
        flash.now[:info] = "Cette analyse est privée."
      else
        flash[:danger] = "Vous n'avez pas l'autorisation d'accéder à l'analyse, le contenu à été rendu privé par son auteur."
        redirect_to reference_path(@comment.reference_id)
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id || current_user.admin
      comment.destroy_with_counters
      redirect_to my_items_items_path
    else
      flash[:danger] = "Vous ne pouvez pas supprimer une analyse qui ne vous appartient pas."
      redirect_to comment_path(params[:id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :reference_id, :timeline_id, :f_0_content, :f_1_content, :f_2_content,
                                    :f_3_content, :f_4_content, :f_5_content, :public, :has_picture, :caption, :delete_picture, :title)
  end
end
