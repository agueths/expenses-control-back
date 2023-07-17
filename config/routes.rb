Rails.application.routes.draw do
  scope :users do
    post 'authenticate' => 'users#authenticate'
    get 'token_validation' => 'users#token_validation'
  end
end
