class ContributionsController < ApplicationController
  def index
    @contribs = {0 => [], 1 => [], 2 => [], 3 => [], 4 => []}
    temp_contribs = {}
    temp_contribs[0] = User.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    temp_contribs[1] = Timeline.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    temp_contribs[2] = Reference.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    temp_contribs[3] = Comment.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
    temp_contribs[4] = Summary.all.pluck(:created_at).group_by{ | date| date.strftime("%B, %Y") }
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
