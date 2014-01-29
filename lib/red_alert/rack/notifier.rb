module RedAlert
  module Rack
    class Notifier
      include RedAlert::Notifier

      def filter_keys
        RACK_DEFAULT_FILTERS + PARAMS_DEFAULT_FILTERS
      end


      def template
      <<-EMAIL
A <%= exception.class %> occured: <%= exception %>
<% if data[:request] %>

===================================================================
Request Body:
===================================================================

<%= data[:request].gsub(/^/, '  ') %>
<% end %>

===================================================================
Rack Environment:
===================================================================

  PID:                     <%= $$ %>
  PWD:                     <%= Dir.getwd %>

  <%= data[:env].to_a.
    sort{|a,b| a.first <=> b.first}.
    map{ |k,v| "%-25s%p" % [k+':', v] }.
    join("\n  ") %>

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
