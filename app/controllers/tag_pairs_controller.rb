class TagPairsController < ApplicationController
  require 'csv'
  def graph
    @matrix = [
        [11975,  0, 0, 0],
        [ 0, 10048, 2060, 6171],
        [ 0, 0, 8090, 8045],
        [ 0,   0,  0, 6907]
    ]
  end

  def reference_pairs
    @tag_pairs = TagPair.where(references: true)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"reference-pairs\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
