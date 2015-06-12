class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def from_timeline
    @best_comment = BestComment.find_by_reference_id( params[:reference_id] )
    @article = Reference.select( :article ).find( params[:reference_id] ).article
    respond_to do |format|
      format.js
    end
  end

  def previous
    refs = Reference.select(:id, :year).order(year: :desc).where(timeline_id: params[:timeline_id])
    i = refs.index{|x| x.id == params[:id].to_i }
    if i == 0
      i = refs.length
    else
      i-=1
    end
    redirect_to reference_path(refs[i].id)
  end

  def next
    refs = Reference.select(:id, :year).order(year: :desc).where(timeline_id: params[:timeline_id])
    i = refs.index{|x| x.id == params[:id].to_i }
    if i == refs.length
      i = 0
    else
      i += 1
    end
    redirect_to reference_path(refs[i].id)
  end

  def from_reference
    if logged_in?
      @my_votes = Vote.where(user_id: current_user.id, reference_id: params[:reference_id], field: params[:field] ).sum(:value)
    end
    Comment.connection.execute("select setseed(#{rand})")
    params[:timeline_id] = Reference.select( :timeline_id ).find( params[:reference_id] ).timeline_id
    case params[:field].to_i
      when 6
        ids = CommentJoin.where( reference_id: params[:reference_id], field: 6 ).pluck( :comment_id )
        @best_fields = Comment.select( :created_at, :id, :title_markdown, :user_id,
                          :f_6_balance ).where( id: ids ).order('random()')
      when 7
        ids = CommentJoin.where( reference_id: params[:reference_id], field: 7 ).pluck( :comment_id )
        @best_fields = Comment.select( :created_at, :id, :caption_markdown, :user_id,
                                       :figure_id, :f_7_balance ).where( id: ids ).order('random()')
      else
        ids = CommentJoin.where( reference_id: params[:reference_id], field: params[:field].to_i ).pluck( :comment_id )
        @best_fields = Comment.select(:created_at, :id, "markdown_#{params[:field]}", :user_id,
                              "f_#{params[:field]}_balance" ).where( id: ids ).order('random()')
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @reference = Reference.new
    @reference.open_access = false
  end

  def create
    @reference = Reference.new( reference_params )
    @reference.user_id = current_user.id
    if params[:title] || params[:doi]
      if params[:title]
        query = params[:reference][:title]
      else
        query = params[:reference][:doi]
      end
      unless query.blank?
        begin
          @reference = fetch_reference( query )
          @reference.article = reference_params[:article]
          @reference.open_access = reference_params[:article]
        rescue ArgumentError
          flash.now[:danger] = "Votre requête n'a rien donné de concluant."
        rescue ConnectionError
          flash.now[:danger] = "Impossible de se connecter aux serveurs qui délivrent les metadonnées."
        rescue StandardError
          flash.now[:danger] = "Une erreur que nous ne savons pas gérer est survenue inopinément !"
        end
      end
      params[:timeline_id] = reference_params[:timeline_id]
      render 'new'
    else
      same = @reference.same_doi
      if same
        flash[:danger] = "Cette référence a déjà été ajouté à cette controverse !"
        redirect_to same
      else
        if @reference.save
          flash[:success] = "Référence ajoutée."
          redirect_to new_comment_path( reference_id: @reference.id )
        else
          params[:timeline_id] = reference_params[:timeline_id]
          render 'new'
        end
      end
    end
  end

  def edit
    @reference = Reference.find( params[:id] )
  end

  def update
    @reference = Reference.find( params[:id] )
    if @reference.user_id == current_user.id
      if @reference.update( reference_params )
        flash[:success] = "Référence modifiée."
        redirect_to @reference
      else
        render 'edit'
      end
    else
      redirect_to @reference
    end
  end

  def show
    @reference = Reference.find(params[:id])
    if logged_in?
      user_id = current_user.id
      @user_rating = @reference.ratings.find_by(user_id: user_id)
      unless @user_rating.nil?
        @user_rating = @user_rating.value
      end
      if @reference.binary != ''
        @user_binary = @reference.binaries.find_by(user_id: user_id)
        unless @user_binary.nil?
          @user_binary = @user_binary.value
        end
      end
      visit = VisiteReference.find_by( user_id: user_id, reference_id: params[:id] )
      if visit
        visit.update( updated_at: Time.zone.now )
      else
        VisiteReference.create( user_id: user_id, reference_id: params[:id] )
      end
      if params[:filter] == "mine"
        @comment = Comment.find_by( user_id: user_id, reference_id: @reference.id )
      else
        @best_comment = BestComment.find_by_reference_id( @reference.id )
      end
    else
      @best_comment = BestComment.find_by_reference_id( @reference.id )
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    if reference.user_id == current_user.id
      reference.destroy_with_counters
      redirect_to my_items_items_path
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :timeline_id,
                                      :open_access, :url, :author, :year, :doi, :journal, :abstract, :article)
  end

end
