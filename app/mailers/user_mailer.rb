class UserMailer < ActionMailer::Base
  default from: "noreply@controversciences.fr"

  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'ControverSciences : Confirmation de création d\'un compte'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'ControverSciences : Réinitialisation du mot de passe'
  end

  def invitation( hash )
    @user = hash[:user_from]
    @message = hash[:message]
    @path = hash[:path]
    mail from: @user.email,
         to: hash[:to],
         subject: "Invitation sur ControverSciences de la part de #{@user.name}"
  end

  def new_account( pending_user )
    @user = pending_user.user
    @why = pending_user.why
    mail from: @user.email,
         to: "thibault.latrille@ens-lyon.fr",
         subject: "Demande de validation pour #{@user.name} sur ControverSciences"
  end

end
