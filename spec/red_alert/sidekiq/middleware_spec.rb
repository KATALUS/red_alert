require 'spec_helper'

describe Sidekiq::Middleware::RedAlert do
  let(:notification) { mock }
  let(:worker_class) { mock }
  let(:msg) { mock }
  let(:queue) { mock }
  let(:error) { RuntimeError.new }
  let(:settings) { { domain: 'example.com' } }

  subject { Sidekiq::Middleware::RedAlert.new settings }

  after { notification.verify }

  it 'wont alert' do
    subject.call(worker_class, msg, queue) { }
  end

  it 'alerts' do
    actual_args = nil
    actual_error = nil
    data = {
      worker_class: worker_class,
      message: msg,
      queue: queue
    }
    notification.expect :alert, nil, [error, data]

    begin
      action = ->(*args) { actual_args = args; notification }
      RedAlert::Sidekiq::Notifier.stub :build, action do
        subject.call(worker_class, msg, queue) { raise error }
      end
    rescue => e
      actual_error = e
    end
    actual_args.length.must_equal 1
    actual_args[0].must_equal settings
    actual_error.must_equal error
  end
end
