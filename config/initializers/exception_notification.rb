require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.

  config.ignored_exceptions = []

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.

  # Notifiers =================================================================

  if Rails.env.production?
    config.add_notifier :slack, {
        :webhook_url => ENV['SLACK_STACK_TRACE_HOOK'],
        :channel => "#stack_trace",
        :additional_parameters => {
            :mrkdwn => true
        }
    }
  else
    config.add_notifier :custom_notifier_name,
                        ->(exception, options) { puts "\n Exception notification fired : #{exception.message} \n"}
  end

end
