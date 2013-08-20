require 'bundler/setup'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'red_alert'
require 'minitest/pride'
require 'minitest/autorun'

Bundler.require :development

Mail.defaults do
  delivery_method :test
end
