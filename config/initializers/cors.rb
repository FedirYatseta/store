Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5174" # Vite dev server для React
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options],
             expose: ["Authorization"] # без цього React не побачить токен
  end
end