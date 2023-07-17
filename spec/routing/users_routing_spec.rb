require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #authenticate' do
      expect(post: '/users/authenticate').to route_to('users#authenticate')
    end

    it 'routes to #token_validation' do
      expect(get: '/users/token_validation').to route_to('users#token_validation')
    end
  end
end
