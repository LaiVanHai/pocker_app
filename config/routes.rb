Rails.application.routes.draw do
  get "/" => "pockers#top"
  post "/pockers/check" => "pockers#check"
  get "/pockers/check" => "pockers#top"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
