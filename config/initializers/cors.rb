Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['CLIENT_SERVER_URL'] # Vite dev server for React
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options],
             expose: ["Authorization"] # without this, React will not see the token
  end
end