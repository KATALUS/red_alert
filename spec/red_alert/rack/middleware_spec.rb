require 'spec_helper'
require 'red_alert/rack'

describe Rack::RedAlert do
  let(:notification) { mock }
  let(:env) { { 'field' => 'variable' } }
  let(:error) { RuntimeError.new }
  let(:settings) { { :domain => 'example.com' } }

  it 'wont alert' do
    inner = mock
    inner.expect :call, nil, [env]
    subject = Rack::RedAlert.new inner, settings
    subject.call env
    inner.verify
  end

  it 'alerts' do
    actual_args = nil
    actual_error = nil
    data = { :env => env }
    inner = OpenStruct.new :error => error
    def inner.call(*args); raise error end
    notification.expect :alert, nil, [error, data]

    begin
      action = lambda {|*args| actual_args = args; notification }
      RedAlert::Rack::Notifier.stub :build, action do
        subject = Rack::RedAlert.new inner, settings
        subject.call env
      end
    rescue => e
      actual_error = e
    end
    actual_args.length.must_equal 1
    actual_args[0].must_equal settings
    actual_error.must_equal error
  end
end
