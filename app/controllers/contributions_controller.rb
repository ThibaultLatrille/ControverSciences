class ContributionsController < ApplicationController
  def index
    @contribs = {0 => [], 1 => [], 2 => [], 3 => [], 4 => []}
    temp_contribs = {}
    temp_contribs[0] = User.order( created_at: :asc ).where(activated: true).pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[1] = Timeline.order( created_at: :asc ).where( private: false ).pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[2] = Reference.order( created_at: :asc ).all.pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[3] = Comment.order( created_at: :asc ).where( public: true ).pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    temp_contribs[4] = Summary.order( created_at: :asc ).where( public: true ).pluck(:created_at).group_by{ | date| I18n.l date.to_date, format: :month }
    date_from  = User.select(:created_at).first.created_at.to_date
    date_to    = Date.today
    @keys = (date_from..date_to).map {|d| Date.new(d.year, d.month, 1) }.uniq[0..-2].map { |date | I18n.l date.to_date, format: :month }
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
