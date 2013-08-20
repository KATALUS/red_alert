module RedAlert
  module Notifier
    def notifier_config
      @notifier_config ||= {}
    end

    def alert(exception, data = {})
      notification = Notification.build notifier_config[:subject], template, exception, data
      mail = Mail.new(
        to: notifier_config[:to],
        from: notifier_config[:from],
        subject: notification.subject,
        body: notification.body
      )
      delivery_method = notifier_config[:transport] || :smpt
      mail.delivery_method delivery_method, notifier_config[:transport_settings]
      mail.deliver!
    end

    %i{ to from subject transport_settings }.each do |name|
      define_method(name){ |value| notifier_config[name] = value }
    end
  end
end
