require 'spec_helper'

class TestNotifier
  include RedAlert::Notifier
  attr_reader :template

  def initialize(template = '')
    @template = template
  end
end

describe RedAlert::Notifier do
  let(:settings) {
    { to: 'recipient@example.com',
      from: 'sender@example.com',
      subject: 'something go bad',
      transport_settings: {
        field: 'custom'
      }
    }
  }

  subject { TestNotifier.build settings }

  describe '::build' do
    %w{ to from subject transport_settings }.each do |field|
      it "builds with #{field} setting" do
        field_sym = field.to_sym
        subject.notifier_settings[field_sym].must_equal settings[field_sym]
      end
    end
  end

  describe '#alert' do
    let(:exception) { RuntimeError.new 'something bad happened' }
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

    subject { TestNotifier.new 'test template <%= exception %> |<%= data[:stuff] %>|' }

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
