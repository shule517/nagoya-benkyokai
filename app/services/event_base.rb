#coding: utf-8
require 'uri'
require_relative "./http"

class EventBase
  public
  attr_reader :event_id,
    :title,
    :description,
    :event_url,
    :started_at,
    :ended_at,
    :url,
    :address,
    :place,
    :lat,
    :lon,
    :limit,
    :accepted,
    :waiting,
    :updated_at,
    :hash_tag,
    :logo,
    :year,
    :month,
    :day,
    :wday,
    :event_type

  private
  attr_reader :data,
    :owner_id,
    :owner_nickname,
    :owner_twitter_id,
    :series

  public
  def initialize(data)
    @data = data
    @event_id = data[:event_id] || data[:id] || ''              # イベントID
    @title = data[:title] || ''                                 # タイトル
    @catch = data[:catch] || ''                                 # キャッチコピー
    @description = data[:description] || ''                     # 詳細
    @event_url = data[:event_url] || data[:public_url] || ''    # 告知ページ
    @started_at = data[:started_at] || data[:starts_at] || ''   # イベント開催日時
    @ended_at = data[:ended_at] || data[:ends_at] || ''         # イベント終了日時
    @url = data[:url] || ''                                     # 参考URL
    @address = data[:address] || ''                             # 開催場所(住所)
    @place = data[:place] || data[:venue_name] || ''            # 開催会場
    @lat = data[:lat] || data[:long] || ''                      # 開催会場の緯度
    @lon = data[:lon] || ''                                     # 開催会場の経度
    @owner_id = data[:owner_id] || ''                           # 主催者ID
    @owner_nickname = data[:owner_nickname] || ''               # 主催者nickname
    @owner_twitter_id = data[:owner_twitter_id] || ''           # 主催者twitter
    @limit = data[:limit] || data[:ticket_limit] || 0           # 定員
    @accepted = data[:accepted] || data[:participants] || 0     # 参加者
    @waiting = data[:waiting] || data[:waitlisted] || ''        # キャンセル待ち
    @updated_at = data[:updated_at] || ''                       # 更新日時
    @hash_tag = data[:hash_tag] || ''                           # ハッシュタグ
    @series = data[:series] || {}                               # グループ情報

    @year = started_at[0...4].to_i
    @month = started_at[5...7].to_i
    @day = started_at[8...10].to_i
    d = Date.new(year, month, day)
    @wday = %w(日 月 火 水 木 金 土)[d.wday]
  end

  def place_enc
    URI.escape(place)
  end

  def limit_over?
    return 0 if accepted == 0
    limit <= accepted
  end

  def twitter_list_id
    "nagoya-#{event_id}"
  end
end
