# frozen_string_literal: true

require 'spec_helper'

describe 'Issue management', type: :request do
  let(:user){ create :user }
  let(:user_headers){ { Authorization: "Bearer #{login(user)}" } }
  let(:user_issue){ create :issue, assignee: user }

  let(:manager){ create :user, role: :manager }
  let(:manager_headers){ { Authorization: "Bearer #{login(manager)}" } }
  let(:manager_issue){ create :issue, assignee: manager }

  let(:issue){ create :issue }

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

  context 'User' do
    it 'lists all my issues' do
      manager_issue.update(name: 'Manager issue')
      user_issue.update(name: 'My issue')
      issue.update(name: 'Call dunder miflin home office')
      get '/api/v1/issues', headers: user_headers
      expect(response.status).to eq(200)
      expect(response.body).to include('My issue')
      expect(response.body).not_to include('Manager issue')
    end

    it 'creates an issue' do
      p = {
        issue: {
          name: 'Do something with Micheal',
          description: 'He is a bit lonely lets help him out'
        }
      }
      post '/api/v1/issues', params: p,
                             as: :json,
                             headers: user_headers

      expect(response.status).to eq(200)
      expect(response.body).to include('Do something with Micheal')
    end

    it 'updates my issue' do
      p = {
        issue: {
          name: 'Walk with Dwitght'
        }
      }
      put "/api/v1/issues/#{user_issue.id}", params: p,
                                             as: :json,
                                             headers: user_headers

      expect(response.status).to eq(200)
      expect(response.body).to include('Walk with Dwitght')
    end

    it 'Can\'t update the manager' do
      p = {
        issue: user_issue.attributes
      }
      p[:issue][:manager_id] = manager.id
      put "/api/v1/issues/#{user_issue.id}", params: p,
                                             as: :json,
                                             headers: user_headers
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['manager']).to eq(nil)
    end

    it 'Can\'t update the status' do
      p = {
        issue: user_issue.attributes
      }
      p[:issue][:status] = :resolved
      put "/api/v1/issues/#{user_issue.id}", params: p,
                                             as: :json,
                                             headers: user_headers

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('pending')
    end

    it 'does not update issues not assigned to me' do
      p = {
        issue: manager_issue.attributes
      }
      p[:issue][:name] = 'Walk with Dwitght'
      put "/api/v1/issues/#{manager_issue.id}", params: p,
                                                as: :json,
                                                headers: user_headers
      expect(response.status).to eq(404)
    end

    it 'deletes my issue' do
      delete "/api/v1/issues/#{user_issue.id}", headers: user_headers, as: :json
      expect(response.status).to eq(204)
    end

    it 'does not deletes other issues' do
      delete "/api/v1/issues/#{issue.id}", headers: user_headers, as: :json
      expect(response.status).to eq(404)
    end
  end
end
