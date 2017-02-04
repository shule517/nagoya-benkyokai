# encoding: utf-8
require 'uri'
require_relative './http'

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

  def find_or_initialize_by
    event = Event.find_by(event_id: event_id)
    if event
      event.title = title
      event.catch = catch
      event.description = description
      event.event_url = event_url
      event.started_at = started_at
      event.ended_at = ended_at
      event.url = url
      event.address = address
      event.place = place
      event.lat = lat
      event.lon = lon
      event.limit = limit
      event.accepted = accepted
      event.waiting = waiting
      event.update_time = updated_at
      event.hash_tag = hash_tag
      event.place_enc = place_enc
      event.source = source
      event.group_url = group_url
      event.group_id = group_id
      event.group_title = group_title
      event.group_logo = group_logo
      event.logo = logo
      return event
    end

    Event.new(event_id: event_id,
      title: title,
      catch: catch,
      description: description,
      event_url: event_url,
      started_at: started_at,
      ended_at: ended_at,
      url: url,
      address: address,
      place: place,
      lat: lat,
      lon: lon,
      limit: limit,
      accepted: accepted,
      waiting: waiting,
      update_time: updated_at,
      hash_tag: hash_tag,
      place_enc: place_enc,
      source: source,
      group_url: group_url,
      group_id: group_id,
      group_title: group_title,
      group_logo: group_logo,
      logo: logo)
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
