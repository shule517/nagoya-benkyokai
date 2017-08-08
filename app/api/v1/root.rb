module V1
  class Root < Grape::API
    version 'v1'
    format :json

    rescue_from :all do |e|
      Root.logger.error(e.message.to_s + "\n" + e.backtrace.join("\n"))
      error!({ message: 'Server Error' }, 500)
    end

    # Each APIs
    mount V1::Users
    mount V1::Events

    # swagger doc
    add_swagger_documentation(
      api_version: 'v1',
      base_path: '/api/test',
      hide_documentation_path: true,
      info: {
        title: '名古屋勉強会らむだ WebAPIドキュメント',
        description: '説明です。'
      }
    )
  end
end
