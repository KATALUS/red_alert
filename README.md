# red_alert
[![Build Status](https://travis-ci.org/KATALUS/red_alert.png?branch=master)](https://travis-ci.org/KATALUS/red_alert)

Error notification middleware.

## Installation

Add this line to your application's Gemfile:

    gem 'red_alert'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install red_alert

## Sidekiq Wireup

```ruby
Sidekiq.configure_server do |c|
  c.server_middleware do |chain|
    chain.add Sidekiq::Middleware::RedAlert,
      to: 'recipient@example.com',
      from: 'sender@example.com',
      subject: "BOOM!: %s",
      transport_settings: {
        address: 'smtp.server.net',
        port: '587',
        user_name: 'user',
        password: 'secret',
        domain: 'example.com',
        authentication: :plain,
        enable_starttls_auto: true
      }
  end
end
```

## Rack Wireup

```ruby
use Rack::RedAlert,
  to: 'recipient@example.com',
  from: 'sender@example.com',
  subject: "BOOM!: %s",
  transport_settings: {
    address: 'smtp.server.net',
    port: '587',
    user_name: 'user',
    password: 'secret',
    domain: 'example.com',
    authentication: :plain,
    enable_starttls_auto: true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
