class PeekBar
  def self.available?
    !defined?(Peek).nil?
  end

  def self.enabled?(current_user)
    return false unless available?

    # The default test.
    %w(development staging).include? Rails.env
  end
end