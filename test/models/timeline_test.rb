require 'test_helper'

class TimelineTest < ActiveSupport::TestCase
  def setup
    @user = users(:thibault)
    # This code is not idiomatically correct.
    @timeline = @user.timelines.build(name: "Lorem ipsum")
  end

  test "micropost should be valid" do
    assert @timeline.valid?
  end

  test "user id should be present" do
    @timeline.user_id = nil
    assert_not @timeline.valid?
  end

  test "name should be present " do
    @timeline.name = " "
    assert_not @micropost.valid?
  end

  test "name should be less than 140 characters" do
    @timeline.name = "a" * 141
    assert_not @timeline.valid?
  end

  test "order should be most ranked first" do
    assert_equal Timeline.first, timelines(:most_ranked)
  end
end
