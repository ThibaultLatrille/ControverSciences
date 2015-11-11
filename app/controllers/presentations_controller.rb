class PresentationsController < ApplicationController
  def student_demo_cup_intro
    render "presentations/student_demo_cup", layout: nil
  end

  def student_demo_cup_protocol
    render "presentations/student_demo_cup_protocol", layout: nil
  end

  def student_demo_cup_core
    render "presentations/student_demo_cup_core", layout: nil
  end

  def student_demo_cup_outro
    render "presentations/student_demo_cup_outro", layout: nil
  end
end
