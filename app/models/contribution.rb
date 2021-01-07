module Contribution

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  def authors
    1 + self.contributors.count
  end

  def editors
    [self.user_id]
  end

  def contributors_name
    list = User.find(self.editors.push(self.contributors.pluck(:user_id)).flatten).pluck(:name)
    if list.length == 1
      list.first
    elsif list.length == 2
      list.join(' et ')
    else
      list[0..-2].join(', ') + ' et ' + list[-1]
    end
  end
end
