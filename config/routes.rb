Rails.application.routes.draw do
  root 'movies#search'
  post '/', to: 'movies#search'
end
