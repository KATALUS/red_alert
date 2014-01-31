module Rack
  class RedAlert
    def initialize(inner, settings)
      @inner = inner
      @settings = settings
    end

    def call(env)
      @inner.call env
    rescue => e
      notification = ::RedAlert::Rack::Notifier.build @settings
      notification.alert e, :env => env
      raise e
    end
  end
end
