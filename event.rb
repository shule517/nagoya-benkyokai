#coding: utf-8
require "./http"

class Event
  attr_reader :data, :event_id, :title, :catch, :description, :event_url, :started_at, :ended_at, :url, :address, :place, :lat, :lon, :owner_id, :owner_nickname, :owner_twitter_id, :limit, :accepted, :waiting, :updated_at, :hash_tag, :event_type, :series, :logo, :year, :month, :day, :wday
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
    @event_type = data[:event_type] || ''
    @series = data[:series] || {}                               # グループ情報

    @year = started_at[0...4].to_i
    @month = started_at[5...7].to_i
    @day = started_at[8...10].to_i
    d = Date.new(year, month, day)
    @wday = %w(日 月 火 水 木 金 土)[d.wday]
  end

  def limit_over?
    return 0 if accepted == 0
    limit <= accepted
  end
end

class ConnpassEvent < Event
  def source
    'connpass'
  end

  def group_url
      series[:url]
  end

  def group_id
      series[:id]
  end

  def group_title
      series[:title]
  end

  def group_logo
    begin
      @group_logo ||= event_doc.css('.event_group_area > div.group_inner > div > a').attribute('style').value.match(%r{url\((.*)\)})[1]
    rescue
      ''
    end
  end

  def owner_twitter_url
    @owner_twitter_url ||= user_doc.css('.social_link > a').attribute('href').value
  end

  def logo
    @logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def event_doc
    @event_doc ||= Http.get_document(event_url)
  end

  def user_doc
    @user_doc ||= Http.get_document("http://connpass.com/user/#{owner_nickname}")
  end
end

class DoorkeeperEvent < Event
  def source
    'doorkeeper'
  end

  def group_url
    @group_url ||= event_doc.css('//meta[property="og:url"]/@content').to_s.gsub(/events.*/, '')
  end

  def group_id
    data[:group]
  end

  def group_title
    @group_title ||= event_doc.css('//meta[property="og:site_name"]/@content').to_s
  end

  def group_logo
    @group_logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def logo
    begin
      @logo ||= event_doc.css('div.event-banner-image > img').attribute('src').value
    rescue
      @logo = group_logo
    end
  end

  def event_doc
    @event_doc ||= Http.get_document(event_url)
  end
end

class AtndEvent < Event
  def source
    'ATND'
  end

  def group_url
  end

  def group_id
  end

  def group_title
  end

  def owner_twitter_url
  end

  def logo
    #@logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def event_doc
    @event_doc ||= Http.get_document(event_url)
  end

  def user_doc
    @user_doc ||= Http.get_document("http://connpass.com/user/#{owner_nickname}")
  end
end
