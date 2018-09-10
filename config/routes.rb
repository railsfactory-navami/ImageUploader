Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine, at: "/documentation"
  mount API => '/'

end
