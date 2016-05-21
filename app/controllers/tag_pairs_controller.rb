class TagPairsController < ApplicationController
  require 'csv'
  def graph
  end

  def reference_pairs
    @tag_pairs = TagPair.includes(:tag_target).includes(:tag_source).where(references: true)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"reference-pairs\''
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def timeline_pairs
    @tag_pairs = TagPair.includes(:tag_target).includes(:tag_source).where(references: false)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"timeline-pairs\''
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
