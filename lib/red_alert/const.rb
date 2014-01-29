module RedAlert
  RACK_DEFAULT_FILTERS = %w{
    rack.request.cookie_hash
    rack.request.cookie_string
    rack.request.form_vars
    rack.session
    rack.session.options
  }.freeze

  PARAMS_DEFAULT_FILTERS = %w{
    password
    password_confirm
    password_confirmation
  }.freeze
end
