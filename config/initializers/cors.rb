Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "*",
      headers: ['x-csrf-token', 'x-requested-with'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false,
      max_age: 86400
  end
end
