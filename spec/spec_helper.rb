require 'bundler/setup'
require 'securerandom'
require 'red_alert'
require 'minitest/autorun'

Bundler.require :development


class Minitest::Spec
  def mock
    Minitest::Mock.new
  end

  def deliveries
    Mail::TestMailer.deliveries
  end

  def rand_s
    SecureRandom.hex
  end
end

Mail.defaults do
  delivery_method :test
end

mail_configuration = Mail::Configuration.instance
def mail_configuration.lookup_delivery_method(*args)
  Mail::TestMailer
end
