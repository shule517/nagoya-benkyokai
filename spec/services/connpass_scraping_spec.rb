require 'rails_helper'
include Api::Connpass

xdescribe ConnpassScraping, type: :request do
  let(:api) { ConnpassApi }
  describe '#find' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    example 'イベントが取得できること', vcr: '#find' do
      expect(event.source).to eq 'connpass'
      expect(event.event_id).to eq 30152
      expect(event.event_url).to eq 'https://jxug.connpass.com/event/30152/'
      expect(event.url).to eq nil # これ必要？
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
      expect(event.catch).to start_with 'にゃごやでも話題の Xamarin を触ってみよう！<br>こんにちは。エクセルソフトの田淵です。 今話題の Xamarin を名古屋でも触ってみましょう！'
      expect(event.description).to start_with 'こんにちは。エクセルソフトの田淵です。 今話題の Xamarin を名古屋でも触ってみましょう！'
      expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
      expect(event.started_at).to eq Time.parse('2016-05-15T13:00:00+09:00')
      expect(event.ended_at).to eq Time.parse('2016-05-15T16:00:00+09:00')
      expect(event.place).to eq '熱田生涯学習センター'
      expect(event.address).to eq '熱田区熱田西町2-13'
      expect(event.lat).to eq '35.126704400000'
      expect(event.lon).to eq '136.899578500000'
      expect(event.limit).to eq 38
      expect(event.accepted).to eq 38
      expect(event.waiting).to eq 0
      expect(event.update_time).to eq Time.parse('2016-05-12 15:27:59 +0900')
      expect(event.hash_tag).to eq 'JXUG'
      expect(event.limit_over?).to eq true
      expect(event.users.count).to eq event.accepted
      expect(event.owners.count).to eq 4
      expect(event.group_id).to eq 1134
      expect(event.group_title).to eq 'JXUG'
      expect(event.group_url).to eq 'https://jxug.connpass.com/'
      expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
    end
  end

  describe '#users' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    let(:users) { event.users }
    it '参加者数が取得できること', vcr: '#users' do
      expect(users.count).to eq event.accepted
    end
    context '参加者がいない場合', vcr: '#users-nothing' do
      # よみかきの前にプログラミング！幼児向け無料体験教室 #2 https://cocomue.connpass.com/event/50505/
      let(:event) { api.find(event_id: 50505) }
      it '参加者数が0であること' do
        expect(users).to be_empty
        expect(users.size).to eq 0
      end
    end
  end

  describe '#user' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    let(:users) { event.users }

    describe '#get_social_id' do
      context 'IDが設定されている場合', vcr: '#get_social_id-exist' do
        let(:user) { users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
        it { expect(user.twitter_id).to eq 'Fumiya_Kume' }
        it { expect(user.facebook_id).to eq '1524732281184852' }
        it { expect(user.github_id).to eq 'fumiya-kume' }
        it { expect(user.linkedin_id).to eq nil }
        it { expect(user.name).to eq 'くぅ - kuxu' }
      end
      context 'IDが設定されていない場合', vcr: '#get_social_id-not_exist' do
        let(:user) { users.select { |user| user.connpass_id == 'h_aka' }.first }
        it { expect(user.twitter_id).to eq nil }
        it { expect(user.facebook_id).to eq nil }
        it { expect(user.github_id).to eq nil }
        it { expect(user.linkedin_id).to eq nil }
        it { expect(user.name).to eq 'h_aka' }
      end
    end

    describe '#image_url' do
      let(:image_url) { user.image_url }
      context 'ユーザ画像が設定されている場合', vcr: '#image_url-exist' do
        let(:user) { users.select { |user| user.connpass_id == 'shule517' }.first }
        it { expect(image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png' }
      end
      context 'ユーザ画面が設定されていない場合', vcr: '#image_url-not_exist' do
        let(:user) { users.select { |user| user.connpass_id == 'h_aka' }.first }
        it { expect(image_url).to eq 'https://connpass.com/static/img/common/user_no_image.gif' }
      end
    end
  end

  describe '#owners', vcr: '#owners' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    let(:owners) { event.owners }

    it '管理者数が取得できること' do
      expect(owners.count).to eq 4
    end
    it '管理者一覧が取得できること' do
      expect(owners.map(&:name)).to match_array %w(田淵義人@エクセルソフト JXUG くぅ\ -\ kuxu Sophy)
    end

    context '参加者ページがある場合'
    context '参加者ページがない場合'
    context '管理者がいない場合' # そんな場合あるの？
  end

  describe '#owner' do
    let(:owners) { event.owners }
    describe '#get_social_id' do
      context 'IDが設定されている場合', vcr: '#owner-social-exist' do
        # 機械学習 名古屋 分科会 #3 https://machine-learning.connpass.com/event/57609/
        let(:event) { api.find(event_id: 57609) }
        let(:owner) { owners.select { |owner| owner.connpass_id == 'antimon2' }.first }
        it { expect(owner.connpass_id).to eq 'antimon2' }
        it { expect(owner.twitter_id).to eq 'antimon2' }
        it { expect(owner.facebook_id).to eq '100001520124191' }
        it { expect(owner.github_id).to eq 'antimon2' }
        it { expect(owner.linkedin_id).to eq nil }
        it { expect(owner.name).to eq 'antimon2' }
        it { expect(owner.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/77/f0/77f0c8eae4e9e877c1a5681a84e6e3d1.png' }
      end
      context 'IDが設定されていない場合', vcr: '#owner-social-not_exist' do
        # 【JISTA中部】ITストラテジスト受験ガイド in 名古屋
        let(:event) { api.find(event_id: 55940) }
        let(:owner) { owners.select { |owner| owner.connpass_id == 'yoshihiro_kanada' }.first }
        it { expect(owner.connpass_id).to eq 'yoshihiro_kanada' }
        it { expect(owner.twitter_id).to eq nil }
        it { expect(owner.facebook_id).to eq nil }
        it { expect(owner.github_id).to eq nil }
        it { expect(owner.linkedin_id).to eq nil }
        it { expect(owner.image_url).to eq 'https://connpass.com/static/img/common/user_no_image.gif' }
      end
    end
    context '画像が設定されている場合', vcr: '#owner-image_url_exist' do
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      let(:owner) { owners.select { |owner| owner.connpass_id == 'ytabuchi' }.first }
      it 'アイコンが取得できること' do
        expect(owner.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/43/9e/439e3f40da4adc279636f04b71c34b26.png'
      end
    end
    context '画像が設定されていない場合', vcr: '#owner-image_url_not_exist' do
      # 機械学習 名古屋 分科会 #3 https://machine-learning.connpass.com/event/57609/
      let(:event) { api.find(event_id: 57609) }
      let(:owner) { owners.select { |owner| owner.connpass_id == 'kmiwa' }.first }
      it 'NO IMAGEアイコンが取得できること' do
        expect(owner.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/f2/58/f2586c61304a16daad06a4b436fbc847.png'
      end
    end
  end

  describe '#catch' do
    context 'キャッチコピーが存在する場合', vcr: '#catch-catch_exist' do
      # 機械学習 名古屋 分科会 #2 https://machine-learning.connpass.com/event/55649/
      let(:event) { api.find(event_id: 55649) }
      it { expect(event.catch).to start_with 'ゼロから作る Deep Learning 読書会＋ハンズオン その2<br>機械学習 名古屋 分科会 機械学習名古屋 勉強会の分科会です。 この分科会では、より理論・実装に重きを置いた勉強をしていきます。' }
    end
    context 'キャッチコピーが存在しない場合', vcr: '#catch-catch_not_exist' do
      # 遺伝的有限集合勉強会 7 https://connpass.com/event/55925/
      let(:event) { api.find(event_id: 55925) }
      it { expect(event.catch).to start_with '概要 HFと有限の世界を勉強しましょう。 第7回は[1]のIV.5.9、第一不完全性定理のあたりを読みます. 予習不要' }
    end
  end

  describe '#logo' do
    let(:logo) { event.logo }
    context 'logoが設定されている場合' do
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      it '設定されたロゴが取得できること', vcr: '#logo.exist' do
        expect(logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
      end
    end
    context 'logoが設定されていない場合' do
      # 遺伝的有限集合勉強会 8 https://connpass.com/event/57258/
      let(:event) { api.find(event_id: 57258) }
      it 'connpassのロゴが取得できること', vcr: '#logo.not_exist' do
        expect(logo).to eq 'https://connpass.com/static/img/468_468.png'
      end
    end
  end

  describe '#participation_url' do
    context 'group_urlがない場合', vcr: '#participation_url group_url-exist' do
      # サブドメイン → connpass.com
      # ちゅーんさんちでHaskellやると楽しいという会 https://connpass.com/event/46087/
      let(:event) { api.find(event_id: 46087) }
      it { expect(event.send(:participation_url)).to eq 'https://connpass.com/event/46087/participation/#participants' }
    end
    context 'group_url.nilじゃない場合', vcr: '#participation_url group_url-not_exist' do
      # ドメイン → jxug.connpass.com
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      it { expect(event.send(:participation_url)).to eq 'https://jxug.connpass.com/event/30152/participation/#participants' }
    end
  end

  describe '#group' do
    context 'グループがある場合', vcr: '#group-exist' do
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      it 'グループ情報が取得できること' do
        expect(event.users.count).to eq event.accepted
        expect(event.owners.count).to eq 4
        expect(event.group_title).to eq 'JXUG'
        expect(event.group_id).to eq 1134
        expect(event.group_url).to eq 'https://jxug.connpass.com/'
        expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
      end
    end
    context 'グループがない場合', vcr: '#group-not_exist' do
      # ちゅーんさんちでHaskellやると楽しいという会 https://connpass.com/event/46087/
      let(:event) { api.find(event_id: 46087) }
      it 'グループ情報が空であること' do
        expect(event.users.count).to eq event.accepted
        expect(event.owners.count).to eq 1
        expect(event.group_title).to eq nil
        expect(event.group_id).to eq nil
        expect(event.group_url).to eq nil
        expect(event.group_logo).to eq nil
      end
    end
  end

  context 'Python東海の参加者数が0である問題を解決', vcr: '#find-no_users' do
    # Python東海 第32回勉強会 https://connpass.com/event/49376/
    let(:event) { api.find(event_id: 49376) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
  end

  context 'チョコ meets ワインの参加者数が足りてない問題を解決', vcr: '#find-less_users' do
    # チョコ meets ワイン https://connpass.com/event/51037/
    let(:event) { api.find(event_id: 51037) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end

  context '勉強会が中止された場合'
  # よみかきの前にプログラミング！幼児向け無料体験教室 #2 https://cocomue.connpass.com/event/50505/
end
