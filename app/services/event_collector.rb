#encoding: utf-8
require_relative './connpass'
require_relative './doorkeeper'
require_relative './atnd'
require_relative './twitter_client'

class EventCollector
  def initialize
    @twitter = TwitterClient.new
  end

  def search(date)
    apis = []
    apis << Connpass.new
    apis << Doorkeeper.new
    events = []
    keywords = ['名古屋', '愛知', '一宮', '瀬戸', '春日井', '犬山', '江南', '小牧', '稲沢', '尾張旭', '岩倉', '豊明', '日進', '清須', '北名古屋', '長久手', '東郷町', '豊山町', '大口町', '扶桑町', '津島', '愛西', '弥富', 'あま', '大治町', '蟹江町', '飛島村', '半田', '常滑', '東海', '大府', '知多', '阿久比町', '東浦町', '南知多町', '美浜町', '武豊町', '岡崎', '碧南', '刈谷', '豊田', '安城', '西尾', '知立', '高浜', 'みよし', '幸田町', '豊橋', '豊川', '蒲郡', '新城', '田原', '設楽町', '東栄町', '豊根村']
    apis.each do |api|
      events += api.search(keywords, date)
    end

    atnd_events = Atnd.new.search(keywords, date)
    ngwords = ["仏教", "クリスマスパーティ", "テロリスト", "国際交流パーティ", "社会人基礎力", "カウントダウンパーティー", "ARMENIAN SONGS", "ブッダ"]
    atnd_events.select! {|event| ngwords.all? {|ngword| !event.title.include?(ngword)} }
    events += atnd_events

    places = ['愛知', '名古屋市', '一宮市', '瀬戸市', '春日井市', '犬山市', '江南市', '小牧市', '稲沢市', '尾張旭市', '岩倉市', '豊明市', '日進市', '清須市', '北名古屋市', '長久手市', '東郷町', '豊山町', '大口町', '扶桑町', '津島市', '愛西市', '弥富市', 'あま市', '大治町', '蟹江町', '飛島村', '半田市', '常滑市', '東海市', '大府市', '知多市', '阿久比町', '東浦町', '南知多町', '美浜町', '武豊町', '岡崎市', '碧南市', '刈谷市', '豊田市', '安城市', '西尾市', '知立市', '高浜市', 'みよし市', '幸田町', '豊橋市', '豊川市', '蒲郡市', '新城市', '田原市', '設楽町', '東栄町', '豊根村',
    '千種区', '東区', '北区', '西区', '中村区', '中区', '昭和区', '瑞穂区', '熱田区', '中川区', '港区', '南区', '守山区', '緑区', '名東区', '天白区']
    ng_places = ["北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛", "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"]
    events.select! {|event| places.any? {|place| event.address.include?(place)} && !ng_places.any? {|ng_place| event.address.include?(ng_place)}}
    today = Time.now.strftime("%Y-%m-%d")
    puts "today:#{today}"
    events.select! {|event| event.started_at >= today}
    events.sort_by! {|event| event.started_at}
  end

  def update_twitter(date)
    events = search(date)
    events.each do |event|
      update_event_to_twitter(event)
    end
  end

  def update_event_to_twitter(event)
    description = "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title} #{event.url}"
    @twitter.create_list(event.twitter_list_id, description)

    users = []
    users.concat(event.owners)
    users.concat(event.users)
    event_users = users.map {|user| user[:twitter_id]}.select {|id| !id.empty?}
    twitter_members = @twitter.list_members(event.twitter_list_id).map {|member| member.screen_name}
    add_users = event_users.select {|user| !twitter_members.include?(user)}

    add_users.each do |twitter_id|
      @twitter.add_list_member(event.twitter_list_id, twitter_id)
    end
  end

  def update
    time = Time.now
    ym = time.strftime("%Y%m")
    events = search([ym])
    time += 24*60*60
    tommorow = time.strftime("%Y-%m-%d")
    events.select! {|event| event.started_at.slice(0, 10) == tommorow}

    puts "events.count:#{events.count} - #{tommorow}"
    events.each do |event|
      puts event
      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{event.title}\n#{event.event_url}\nhttps://twitter.com/nagoya_lambda/lists/nagoya-#{event.event_id}"
      if !event.hash_tag.empty?
        message += "\n##{event.hash_tag}"
      end
      @twitter.tweet(message)
    end
  end
end
