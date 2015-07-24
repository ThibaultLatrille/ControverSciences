class ContributionsController < ApplicationController
  def index
    @contribs = {0 => [], 1 => [], 2 => [], 3 => [], 4 => []}
    temp_contribs = {}
    temp_contribs[0] = User.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[1] = Timeline.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[2] = Reference.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[3] = Comment.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[4] = Summary.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    @keys = temp_contribs.values.map{ |x| x.keys }.flatten.uniq[0..-2]
    (0..4).each do |contrib|
      sum = 0
      @keys.each do |key|
        if params[:filter] == "freq"
          sum = temp_contribs[contrib][key].blank? ? 0 : temp_contribs[contrib][key].length
        else
          sum += temp_contribs[contrib][key].blank? ? 0 : temp_contribs[contrib][key].length
        end
        @contribs[contrib] << sum
      end
    end
  end
end
