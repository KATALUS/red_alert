module Sidekiq
  module Middleware
    class RedAlert
      def initialize(settings)
        @settings = settings
      end

      def call(worker_class, message, queue)
        yield
      rescue => e
        notification = ::RedAlert::Sidekiq::Notifier.build @settings
        notification.alert e,
          :worker_class => worker_class,
          :message => message,
          :queue => queue
        raise e
      end
    end
  end
end
