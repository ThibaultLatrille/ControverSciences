class TasksController < ApplicationController
  def send_patches
    def url_options
      if Rails.env.production?
        {:host => "controversciences.org", :protocol => 'https'}
      else
        {:host => "127.0.0.1:3000"}
      end
    end

    patches = GoPatch.all
    mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
    patches.group_by(&:target_user_id).map do |target_user_id, target_patches|
      min_countdown = target_patches.min_by(&:countdown).countdown
      if min_countdown <= 0
        @target_user = User.find(target_user_id)
        @patches = target_patches
        message = {
            :subject => "#{@target_user.name}, #{t('controllers.notifs_patches')}",
            :from => "ControverSciences.org <contact@controversciences.org>",
            :to => @target_user.email,
            :html => render_to_string( 'user_mailer/patches', layout: nil).to_str
        }
        mg_client.send_message "controversciences.org", message
        @emails ||= 0
        @emails +=1
        GoPatch.update_counters(target_patches.map(&:id), countdown: 7)
      else
        GoPatch.decrement_counter(:countdown, target_patches.map(&:id))
      end
    end
  end

  def send_notifications
    def url_options
      if Rails.env.production?
        {:host => "controversciences.org", :protocol => 'https'}
      else
        {:host => "127.0.0.1:3000"}
      end
    end

    users = User.joins(:user_detail)
                .where.not(user_details: {send_email: false})
                .where(user_details: {countdown: 0})
                .where(activated: true)
    @empty_comments = Reference.where(title_fr: '').count
    @empty_summaries = Timeline.where(nb_summaries: 0).where.not(private: true).where.not(nb_references: 0..3).count
    @empty_references = Timeline.where(nb_references: 0..3).where.not(private: true).count
    mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
    users.find_each do |user|
      if (user.nb_notifs + user.notifications_all) > 4
        @user_notif = user
        message = {
            :subject => "#{@user_notif.name}, #{t('controllers.notifs_news')}",
            :from => "ControverSciences.org <contact@controversciences.org>",
            :to => @user_notif.email,
            :html => render_to_string( 'user_mailer/notifications', layout: nil).to_str
        }
        mg_client.send_message "controversciences.org", message
        @emails ||= 0
        @emails +=1
        UserDetail.update_counters(user.user_detail.id, countdown: user.user_detail.frequency)
      end
    end
    not_activated_users = User.joins(:user_detail).joins(:pending_user)
                              .where.not(pending_users: {refused: true})
                              .where(user_details: {countdown: 0})
                              .where(activated: false)
    @resend_activation = true
    not_activated_users.find_each do |user|
      @user = user
      @user.create_activation_digest
      @user.update_columns(activation_digest: @user.activation_digest)
      message = {
          :subject => t('controllers.activation_email'),
          :from => "ControverSciences.org<activation@controversciences.org>",
          :to => @user.email,
          :html => render_to_string( 'user_mailer/account_activation', layout: nil).to_str
      }
      mg_client.send_message "controversciences.org", message
      @emails ||= 0
      @emails +=1
      UserDetail.update_counters(user.user_detail.id, countdown: (15+rand(30)))
    end
    UserDetail.where.not(countdown: 0).update_all("countdown = countdown - 1")
  end

  def notif_slack
    if @emails > 0
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new
      client.chat_postMessage(channel: ENV['SLACK_MAILS_ID'], text: "#{@emails} #{t('controllers.email_sent')}")
    end
  end
end
