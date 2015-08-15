module PeekBarHelper
  # Typical Peek Integration
  def peek_enabled?
    PeekBar.enabled?(current_user)
  end
end