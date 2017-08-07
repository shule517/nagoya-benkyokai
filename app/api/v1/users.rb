module V1
  class Users < Grape::API
    resource 'users', desc: 'ユーザー' do
      desc 'ユーザーリストの取得'
      get do
        present User.all, with: Entities::UsersEntity
      end

      desc 'ユーザ情報の取得'
      params do
        requires :id, type: Integer, desc: 'User id.'
      end
      route_param :id do
        get do
          present User.find(params[:id]), with: Entities::UsersEntity
        end
      end
    end
  end
end
