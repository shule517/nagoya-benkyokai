module V1
  class Events < Grape::API
    resource 'events' do
      desc 'イベントリストの取得'
      get do
        present Event.all, with: Entities::EventsEntity
      end

      desc 'イベント情報の取得'
      params do
        requires :id, type: Integer, desc: 'Event id.'
      end
      route_param :id do
        get do
          present Event.find(params[:id]), with: Entities::EventsEntity
        end
      end
    end
  end
end
