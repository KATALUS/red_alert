require 'spec_helper'

describe RedAlert::Rack::Notifier do
  subject { RedAlert::Rack::Notifier.new }

  before do
    subject.to 'recipient@example.com'
    subject.from 'sender@example.com'
    subject.transport_settings({})
  end

  after { deliveries.clear }

  it 'alerts' do
    expected = rand_s
    begin
      raise 'boom'
    rescue => e
      subject.alert(e, :request => 'data', :env => { 'in' => expected })
      message = deliveries.first
      message.body.to_s.must_include expected
    end
  end

  it 'removes sensitive rack params' do
    expected = rand_s
    begin
      raise 'boom'
    rescue => e
      subject.alert(e, :request => 'data', :env => { 'rack.session' => expected })
      message = deliveries.first
      message.body.to_s.wont_include expected
    end
  end
end
