module RedAlert
  module Sidekiq
    class Notifier
      include RedAlert::Notifier

      def template
      <<-EMAIL
A <%= exception.class %> occured: <%= exception %>

===================================================================
Message:
===================================================================

<%= data[:message].to_a.
  sort{|a,b| a.first <=> b.first}.
  map{ |k,v| "%-25s%p" % [k+':', v] }.
  join("\n  ") %>

===================================================================
Sidekiq Environment:
===================================================================

  PID:                     <%= $$ %>
  PWD:                     <%= Dir.getwd %>

  Worker Class:            <%= data[:worker_class] %>
  Queue:                   <%= data[:queue] %>

<% if exception.respond_to?(:backtrace) %>
===================================================================
Backtrace:
===================================================================

  <%= exception.backtrace.join("\n  ") %>
<% end %>
      EMAIL
      end
    end
  end
end
