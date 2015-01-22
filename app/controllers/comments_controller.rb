class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    comment = Comment.find_by( user_id: current_user.id, reference_id: params[:reference_id] )
    if comment
      redirect_to edit_comment_path( id: comment.id, parent_id: params[:parent_id] )
    else
      @comment = Comment.new
      if params[:parent_id]
        @parent = Comment.find(params[:parent_id])
        @comment = @parent
      else
        reference = Reference.select(:id, :timeline_id).find( params[:reference_id] )
        @comment.reference_id = reference.id
        @comment.timeline_id = reference.timeline_id
      end
      @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
    end
  end

  def create
    @comment = Comment.new( comment_params )
    @comment.user_id = current_user.id
    parent_id = params[:comment][:parent_id]
    if @comment.save_with_markdown( timeline_url( comment_params[:timeline_id] ) )
      if parent_id
        CommentRelationship.create(parent_id: parent_id, child_id: @comment.id)
      end
      flash[:success] = "Analyse enregistrée"
      redirect_to comment_path( @comment.id )
    else
      @list = Reference.where( timeline_id: comment_params[:timeline_id] ).pluck( :title, :id )
      if parent_id
        @parent = Comment.find( parent_id )
      end
      render 'new'
    end
  end

  def edit
    @my_comment = Comment.find( params[:id] )
    @comment = @my_comment
    @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
    if params[:parent_id]
      @parent = Comment.find(params[:parent_id])
      if @parent.user_id != current_user.id
        for fi in 1..5 do
          @comment["f_#{fi}_content".to_sym] += "\n" + @parent["f_#{fi}_content".to_sym]
        end
      else
        @parent = nil
      end
    end
  end

  def update
    @comment = Comment.find( params[:id] )
    @my_comment = Comment.find( params[:id] )
    if @comment.user_id == current_user.id
      for fi in 1..5 do
        @comment["f_#{fi}_content".to_sym] = comment_params["f_#{fi}_content".to_sym]
      end
      if @comment.update_with_markdown( timeline_url( @comment.timeline_id ) )
        flash[:success] = "Analyse modifiée"
        redirect_to @comment
      else
        @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
        if params[:comment][:parent_id]
          @parent = Comment.find(params[:comment][:parent_id])
        end
        render 'edit'
      end
    else
      redirect_to @comment
    end
  end

  def show
    @comment = Comment.select( :id, :user_id, :reference_id, :timeline_id,
                               :markdown_1, :markdown_2, :markdown_3, :markdown_4,
                               :markdown_5, :balance, :best,
                               :created_at
                              ).find(params[:id])
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id && !comment.best
      comment.destroy_with_counters
      redirect_to my_items_comments_path
    else
      flash[:danger] = "Cette analyse est la meilleure et ne peux être supprimé"
      redirect_to comment_path(params[:id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :reference_id, :timeline_id, :f_1_content, :f_2_content,
                                    :f_3_content, :f_4_content, :f_5_content)
  end
end
