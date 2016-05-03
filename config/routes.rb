Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Adding Custom Routes for Appointments Resource
  get 'appointments'        => 'appointments#list'
  post 'appointments'       => 'appointments#create'
  get 'appointments/:id'    => 'appointments#list'
  put 'appointments/:id'    => 'appointments#update'
  patch 'appointments/:id'  => 'appointments#update'
  delete 'appointments/:id' => 'appointments#delete'

  match '*unmatched_route', :to => 'application#error_not_found!', :via => :all
end
