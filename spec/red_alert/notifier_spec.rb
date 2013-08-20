require 'spec_helper'

class TestNotifier
  include RedAlert::Notifier
  attr_reader :template

  def initialize(template)
    @template = template
    @notifier_config = { transport: :test }
  end
end

describe RedAlert::Notifier do
  subject { TestNotifier.new 'test template <%= exception %> |<%= data[:stuff] %>|' }

  describe '#alert' do
    let(:exception) { RuntimeError.new 'something bad happened' }
    let(:deliveries) { Mail::TestMailer.deliveries }
    let(:to) { 'recipient@example.com' }
    let(:from) { 'sender@example.com' }
    let(:mail_subject) { 'test subject %s' }
    let(:data) { { stuff: 'here' } }
    let(:settings) { {
      domain: 'example.com',
      address: 'smtp.sendgrid.net',
      port: '587',
      user_name: 'the_user',
      password: 'secret',
      authentication: :plain,
      enable_starttls_auto: true
    } }

    before do
      subject.to to
      subject.from from
      subject.subject mail_subject
      subject.transport_settings settings
    end

    after { deliveries.clear }

    it 'delivers mail' do
      result = subject.alert exception, data

      deliveries.length.must_equal 1
      notification = deliveries.first
      result.must_equal notification
      notification.to.must_include to
      notification.from.must_include from
      notification.subject.must_equal 'test subject something bad happened'
      notification.body.to_s.must_equal 'test template something bad happened |here|'
    end

    it 'uses settings' do
      result = subject.alert(exception).delivery_method.settings
      result.must_equal settings
    end
  end
end
