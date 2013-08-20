require 'spec_helper'
require 'red_alert/rack'

describe RedAlert::Rack::Notifier do
  subject { RedAlert::Rack::Notifier.new }

  before do
    subject.to 'recipient@example.com'
    subject.from 'sender@example.com'
    subject.transport_settings({})
  end

  after { deliveries.clear }

  it 'alerts' do
    begin
      raise 'boom'
    rescue => e
      subject.alert(e, request: 'data', env: { 'in' => 'out' }).body.wont_be_nil
      deliveries.length.must_be :>, 0
    end
  end
end
