class EventCollector
  def initialize
    @twitter = TwitterClient.new
  end

  def search(date, after_today = true)
    puts "collect date: #{date}"
    apis = []
    apis << Api::Connpass::ConnpassApi.new
    apis << Api::Doorkeeper::DoorkeeperApi.new
    events = []
    keywords = ['愛知', '中部', '東海', '名古屋', '豊橋', '豊田', '岡崎', '一宮', '春日井', '安城', '豊川', '西尾', '刈谷', '小牧', '稲沢', '半田', '瀬戸', '東海', '日進', '大府', '江南', '北名古屋', '尾張旭', 'あま', '知多', '知立', '蒲郡', 'みよし', '犬山', '碧南', '清須', '豊明', '長久手', '津島', '田原', '愛西', '高浜', '常滑', '東浦', '東郷', '幸田', '武豊', '岩倉', '弥富', '新城', '扶桑', '大治', '蟹江', '阿久比', '大口', '美浜', '豊山', '南知多', '飛島', '設楽', '東栄', '豊根']
    apis.each do |api|
      events += api.search(keyword: keywords, ym: date)
    end

    atnd_events = Api::Atnd::AtndApi.new.search(keyword: keywords, ym: date)
    ngwords = %w(仏教 クリスマスパーティ テロリスト 国際交流パーティ 社会人基礎力 カウントダウンパーティー ARMENIAN SONGS ブッダ BrightWoman 幸せの種まき 幸せの花 ブランディング オシャレな古城 受講料 mana×comu 投資 心理学 ヨガ ガン ボランティア 病 ベジタリアン ピアノ 幸せ Hearthstone ゆかりオフ オシャレカフェ eco検定 アニマルセラピー 介護)
    atnd_events.select! { |event| ngwords.all? { |ngword| !event.title.include?(ngword) } }
    events += atnd_events

    places = ['愛知', '名古屋市', '一宮市', '瀬戸市', '春日井市', '犬山市', '江南市', '小牧市', '稲沢市', '尾張旭市', '岩倉市', '豊明市', '日進市', '清須市', '北名古屋市', '長久手市', '東郷町', '豊山町', '大口町', '扶桑町', '津島市', '愛西市', '弥富市', 'あま市', '大治町', '蟹江町', '飛島村', '半田市', '常滑市', '東海市', '大府市', '知多市', '阿久比町', '東浦町', '南知多町', '美浜町', '武豊町', '岡崎市', '碧南市', '刈谷市', '豊田市', '安城市', '西尾市', '知立市', '高浜市', 'みよし市', '幸田町', '豊橋市', '豊川市', '蒲郡市', '新城市', '田原市', '設楽町', '東栄町', '豊根村',
    '千種区', '東区', '北区', '西区', '中村区', '中区', '昭和区', '瑞穂区', '熱田区', '中川区', '港区', '南区', '守山区', '緑区', '名東区', '天白区']
    ng_places = ['北海道', '青森', '岩手', '宮城', '秋田', '山形', '福島', '茨城', '栃木', '群馬', '埼玉', '千葉', '東京', '神奈川', '新潟', '富山', '石川', '福井', '山梨', '長野', '岐阜', '静岡', '三重', '滋賀', '京都', '大阪', '兵庫', '奈良', '和歌山', '鳥取', '島根', '岡山', '広島', '山口', '徳島', '香川', '愛媛', '高知', '福岡', '佐賀', '長崎', '熊本', '大分', '宮崎', '鹿児島', '沖縄', '横浜']
    events.select! { |event| places.any? { |place| event.address&.include?(place) } && !ng_places.any? { |ng_place| event.address&.include?(ng_place) } }
    today = Time.now.strftime('%Y-%m-%d')
    puts "today:#{today}"
    if after_today
      events.select! { |event| event.started_at >= today }
    end
    events = events.group_by { |event| event.event_id }.map { |event| event[1].first }
    events.sort_by! { |event| event.started_at }
  end
end
