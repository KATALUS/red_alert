require 'spec_helper'
require 'red_alert/sidekiq'

describe RedAlert::Sidekiq::Notifier do
  subject { RedAlert::Sidekiq::Notifier.new }

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
      subject.alert(e, message: { 'args' => ['something', 'useful'] }).body.wont_be_nil
      deliveries.length.must_be :>, 0
    end
  end
end
