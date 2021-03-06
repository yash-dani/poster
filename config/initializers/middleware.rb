Rails.application.config.middleware.instance_eval do
  # if Rails.env.development?
  #   use Rack::LiveReload, no_swf: true
  # end

  # if Rails.env.staging?
  #   use StagingAccessMiddleware
  # end

  # use BlockBadRequests
  # use RedirectToSitemap
  use Rack::Attack

  if Rails.env.development?
    use Rack::Timeout, service_timeout: 30, wait_timeout: false
    Rack::Timeout.unregister_state_change_observer(:logger)
  else
    use Rack::Timeout, service_timeout: 25, wait_timeout: false
  end

end
