require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  it '過去の勉強会は表示しないこと' do
    Event.create(started_at: Time.now.yesterday)
    get :index
    expect(assigns(:upcoming_events).length).to eq 0
  end

  it '今日開催の勉強会は表示すること' do
    Event.create(started_at: Time.now)
    get :index
    expect(assigns(:upcoming_events).length).to eq 1
  end

  describe 'GET #tag' do
    it 'returns http success' do
      get :tag
      expect(response).to have_http_status(:success)
    end
  end
end
