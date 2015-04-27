class StaticPagesController < ApplicationController
  def home
    @timelines = Timeline.order(:score => :desc).first(8)
  end

  def empty_comments
    @references = Reference.select(:id, :title, :timeline_id, :created_at).order(:created_at => :desc).where( title_fr: nil )
  end

  def empty_summaries
    @timelines = Timeline.select(:id, :name, :created_at).order(:created_at => :desc).where( nb_summaries: 0 ).where.not( nb_references: 0..3 )
  end

  def empty_references
    @timelines = Timeline.select(:id, :name, :created_at).order(:created_at => :desc).where( nb_references: 0..3 )
  end

  def newsletter
  end
end
