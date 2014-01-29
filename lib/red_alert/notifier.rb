require 'mail'

module RedAlert
  module Notifier
    def self.included(klass)
      klass.extend ClassMethods
    end

    def notifier_settings
      @notifier_settings ||= {}
    end

    def filter_keys
      PARAMS_DEFAULT_FILTERS
    end

    def alert(exception, data = {})
      cleaner = Cleaner.new(filter_keys)
      cleaned_data = cleaner.scrub data
      notification = Notification.build notifier_settings[:subject], template, exception, cleaned_data
      mail = Mail.new(
        to: notifier_settings[:to],
        from: notifier_settings[:from],
        subject: notification.subject,
        body: notification.body
      )
      mail.delivery_method :smtp, notifier_settings[:transport_settings]
      mail.deliver!
    end

    %i{ to from subject transport_settings }.each do |name|
      define_method(name){ |value| notifier_settings[name] = value }
    end

    module ClassMethods
      def build(settings)
        notifier = self.new
        notifier.to settings.fetch(:to)
        notifier.from settings.fetch(:from)
        notifier.subject settings.fetch(:subject)
        notifier.transport_settings settings.fetch(:transport_settings)
        notifier
      end
    end
  end
end
