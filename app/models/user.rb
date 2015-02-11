class User < ActiveRecord::Base
  has_many :timelines, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :summaries, dependent: :destroy
  has_many :links
  has_many :votes, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :timeline_contributors, dependent: :destroy
  has_many :reference_contributors, dependent: :destroy
  has_many :notification_timelines, dependent: :destroy
  has_many :notification_references, dependent: :destroy
  has_many :notification_selections, dependent: :destroy
  has_many :notification_comments, dependent: :destroy
  has_many :notification_selection_losses, dependent: :destroy
  has_many :notification_selection_wins, dependent: :destroy
  has_many :notification_summaries, dependent: :destroy
  has_many :notification_summary_selections, dependent: :destroy
  has_many :notification_summary_selection_losses, dependent: :destroy
  has_many :notification_summary_selection_wins, dependent: :destroy
  has_many :visite_references, dependent: :destroy
  has_many :visite_timelines, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token, :why, :invalid_email, :terms_of_service
  before_save   :downcase_email
  before_create :create_activation_digest

  validates_acceptance_of :terms_of_service
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true,
  #                  format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  validate :email_domain

  def email_domain
    mydomain = self.email.partition("@")[2]
    Domain.all.pluck(:name).each do |domain|
      if mydomain.include? domain
        return true
      end
    end
    if self.why.blank?
      errors.add(:email, 'appartient à un domaine non connu.
            Veuillez donner des informations complémentaires.')
    else
      self.invalid_email = true
    end
  end

 # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.days.ago
  end

  def notifications_timeline
    NotificationTimeline.where( user_id: self.id ).count
  end

  def notifications_summary
    NotificationSummary.where( user_id: self.id ).count
  end

  def notifications_reference
    NotificationReference.where( user_id: self.id ).count
  end

  def notifications_comment
    NotificationComment.where( user_id: self.id ).count
  end

  def notifications_selection
    NotificationSelection.where( user_id: self.id ).count
  end

  def notifications_summary_selection
    NotificationSummarySelection.where( user_id: self.id ).count
  end

  def notifications_all
    notifications_timeline+notifications_summary+notifications_reference+
        notifications_comment+notifications_selection+notifications_summary_selection
  end

  def notifications_win
    NotificationSelectionWin.where( user_id: self.id ).count
  end

  def notifications_loss
    NotificationSelectionLoss.where( user_id: self.id ).count
  end

  def notifications_summary_win
    NotificationSummarySelectionWin.where( user_id: self.id ).count
  end

  def notifications_summary_loss
    NotificationSummarySelectionLoss.where( user_id: self.id ).count
  end

  def notifications_all_important
    notifications_win+notifications_loss+notifications_summary_win+
        notifications_summary_loss
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end
end
