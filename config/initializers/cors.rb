client_server_url = ENV["CLIENT_SERVER_URL"]

if client_server_url.present?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins client_server_url # Vite dev server for React
      resource "*",
               headers: :any,
               methods: %i[get post put patch delete options],
               expose: ["Authorization"] # without this, React will not see the token
    end
  end
else
  Rails.logger.warn("CLIENT_SERVER_URL is not set; cross-origin requests are disabled.")
end