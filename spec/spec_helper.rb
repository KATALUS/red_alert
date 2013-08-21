require 'bundler/setup'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'red_alert'
require 'minitest/pride'
require 'minitest/autorun'

Bundler.require :development

Mail.defaults do
  delivery_method :test
end

mail_configuration = Mail::Configuration.instance
def mail_configuration.lookup_delivery_method(*args)
  Mail::TestMailer
end

def deliveries
  Mail::TestMailer.deliveries
end

def mock
  Minitest::Mock.new
end
