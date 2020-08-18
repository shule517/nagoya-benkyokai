module V1
  class Counts < Grape::API
    resource 'counts' do
      desc '日別イベント数の取得'
      get do
        # https://cal-heatmap.com/#data-format に合わせて日付をunix timestampに変換
        present Event.scheduled
                    .group_by_day(:started_at)
                    .count
                    .deep_transform_keys { |date| date.to_time.to_i }
      end
    end
  end
end
