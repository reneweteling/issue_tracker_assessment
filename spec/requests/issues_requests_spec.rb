# frozen_string_literal: true

require 'spec_helper'

describe 'Issue management', type: :request do
  let(:user){ create :user }
  let(:auth_token){ login(user) }

  def login(user)
    auth = {
      auth: {
        email: user.email,
        password: 'test123'
      }
    }

    post '/api/v1/user_token', params: auth, as: :json
    expect(response.status).to eq(201)
    JSON.parse(response.body)['jwt']
  end

  it 'does nothing when not authorized' do
    get '/api/v1/issues'
    expect(response.status).to eq(401)
  end

  it 'lists all issues' do
    get '/api/v1/issues', headers: { Authorization: "Bearer #{auth_token}" }
    expect(response.status).to eq(200)
  end
end
