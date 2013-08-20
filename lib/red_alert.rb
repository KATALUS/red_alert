module RedAlert
end

Dir[File.expand_path("red_alert/*.rb", __FILE__)].each { |f| require f }
